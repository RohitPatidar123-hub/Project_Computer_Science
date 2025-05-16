#include <algorithm>
#include <cmath>
#include <cstdint>
#include <gmpxx.h>
#include <iostream>
#include <mpi.h>
#include <vector>

const int BITS_PER_BLOCK = 64;

std::vector<int> generatePrimes(int limit) {
  std::vector<bool> is_prime(limit + 1, true);
  is_prime[0] = is_prime[1] = false;
  int sqrt_limit = static_cast<int>(std::sqrt(limit));
  for (int p = 2; p <= sqrt_limit; ++p) {
    if (is_prime[p]) {
      for (int multiple = p * p; multiple <= limit; multiple += p) {
        is_prime[multiple] = false;
      }
    }
  }
  std::vector<int> primes;
  for (int p = 2; p <= limit; ++p) {
    if (is_prime[p]) {
      primes.push_back(p);
    }
  }
  return primes;
}

int legendreSymbol(const mpz_class &a, int p) {
  mpz_class a_mod_p = a % p;
  if (a_mod_p == 0) {
    return 0;
  }
  int exponent = (p - 1) / 2;
  mpz_class result;
  mpz_powm_ui(result.get_mpz_t(), a_mod_p.get_mpz_t(), exponent,
              mpz_class(p).get_mpz_t());
  if (result == 1) {
    return 1;
  } else if (result == p - 1) {
    return -1;
  } else {
    return 0;
  }
}

mpz_class compute_Qx(int x, const mpz_class &m, const mpz_class &n) {
  mpz_class x_plus_m = x + m;
  mpz_class Qx = x_plus_m * x_plus_m - n;
  return Qx;
}

std::vector<int> factorize_Qx(mpz_class Qx,
                              const std::vector<int> &factor_base) {
  std::vector<int> exponents(factor_base.size(), 0);
  if (Qx == 0) {
    return {};
  }
  if (Qx < 0) {
    exponents[0] = 1;
    Qx = -Qx;
  }
  for (size_t i = 1; i < factor_base.size(); ++i) {
    int p = factor_base[i];
    while (mpz_divisible_ui_p(Qx.get_mpz_t(), p)) {
      exponents[i]++;
      Qx /= p;
    }
  }
  if (Qx == 1) {
    return exponents;
  } else {
    return {};
  }
}

void printMatrix(const std::vector<std::vector<int>> &matrix,
                 const std::vector<int> &factor_base) {
  std::cout << "Exponent Matrix (mod 2):\n";
  std::cout << "Row\t";
  for (const auto &p : factor_base) {
    std::cout << p << "\t";
  }
  std::cout << "\n";
  for (size_t i = 0; i < matrix.size(); ++i) {
    std::cout << i + 1 << "\t";
    for (const auto &val : matrix[i]) {
      std::cout << val % 2 << "\t";
    }
    std::cout << "\n";
  }
  std::cout << "\n";
}

std::vector<std::vector<uint64_t>>
convertToBitPacked(const std::vector<std::vector<int>> &matrix_mod2) {
  size_t num_rows = matrix_mod2.size();
  if (num_rows == 0)
    return {};
  size_t num_cols = matrix_mod2[0].size();
  size_t blocks = (num_cols + BITS_PER_BLOCK - 1) / BITS_PER_BLOCK;
  std::vector<std::vector<uint64_t>> bit_packed_matrix(
      num_rows, std::vector<uint64_t>(blocks, 0));

  for (size_t i = 0; i < num_rows; ++i) {
    for (size_t j = 0; j < num_cols; ++j) {
      if (matrix_mod2[i][j] % 2 != 0) {
        size_t block = j / BITS_PER_BLOCK;
        size_t bit = j % BITS_PER_BLOCK;
        bit_packed_matrix[i][block] |= (1ULL << bit);
      }
    }
  }
  return bit_packed_matrix;
}

std::vector<std::vector<int>> findDependenciesOptimized(
    const std::vector<std::vector<int>> &matrix_mod2_input,
    size_t factor_base_size) {

  std::vector<std::vector<uint64_t>> matrix =
      convertToBitPacked(matrix_mod2_input);
  size_t num_rows = matrix.size();
  if (num_rows == 0)
    return {};
  size_t num_cols = factor_base_size;
  size_t blocks = (num_cols + BITS_PER_BLOCK - 1) / BITS_PER_BLOCK;

  std::vector<std::vector<uint64_t>> identity(
      num_rows, std::vector<uint64_t>(
                    (num_rows + BITS_PER_BLOCK - 1) / BITS_PER_BLOCK, 0));
  for (size_t i = 0; i < num_rows; ++i) {
    size_t block = i / BITS_PER_BLOCK;
    size_t bit = i % BITS_PER_BLOCK;
    identity[i][block] |= (1ULL << bit);
  }

  size_t row = 0;
  for (size_t col = 0; col < num_cols && row < num_rows; ++col) {
    size_t pivot = row;
    // Find pivot row
    while (pivot < num_rows) {
      size_t block = col / BITS_PER_BLOCK;
      size_t bit = col % BITS_PER_BLOCK;
      if (matrix[pivot][block] & (1ULL << bit))
        break;
      pivot++;
    }

    if (pivot == num_rows)
      continue;

    if (pivot != row) {
      std::swap(matrix[row], matrix[pivot]);
      std::swap(identity[row], identity[pivot]);
    }

    for (size_t r = 0; r < num_rows; ++r) {
      if (r != row) {
        size_t block = col / BITS_PER_BLOCK;
        size_t bit = col % BITS_PER_BLOCK;
        if (matrix[r][block] & (1ULL << bit)) {
          for (size_t b = 0; b < blocks; ++b) {
            matrix[r][b] ^= matrix[row][b];
            identity[r][b] ^= identity[row][b];
          }
        }
      }
    }
    row++;
  }

  std::vector<std::vector<int>> dependencies;
  for (size_t r = 0; r < num_rows; ++r) {
    bool is_zero = true;
    for (size_t b = 0; b < blocks; ++b) {
      if (matrix[r][b] != 0) {
        is_zero = false;
        break;
      }
    }
    if (is_zero) {
      std::vector<int> dependency(num_rows, 0);
      for (size_t b = 0; b < identity[r].size(); ++b) {
        uint64_t block = identity[r][b];
        for (size_t bit = 0; bit < BITS_PER_BLOCK; ++bit) {
          size_t idx = b * BITS_PER_BLOCK + bit;
          if (idx >= num_rows)
            break;
          if (block & (1ULL << bit)) {
            dependency[idx] = 1;
          }
        }
      }
      dependencies.push_back(dependency);
    }
  }
  return dependencies;
}

int main(int argc, char *argv[]) {
  MPI_Init(&argc, &argv);
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

  std::string n_str;
  if (world_rank == 0) {
    // Example large number (replace with desired 35-40 digit number)
    n_str = "5486150758706356557450962117";
    std::cout << "Quadratic Sieve (QS) Implementation\n";
    std::cout << "===================================\n";
    std::cout << "Target number (n): " << n_str << std::endl;
  }

  int n_str_length = n_str.size();
  MPI_Bcast(&n_str_length, 1, MPI_INT, 0, MPI_COMM_WORLD);

  char *n_str_cstr = new char[n_str_length + 1];
  if (world_rank == 0) {
    std::copy(n_str.begin(), n_str.end(), n_str_cstr);
    n_str_cstr[n_str_length] = '\0';
  }
  MPI_Bcast(n_str_cstr, n_str_length + 1, MPI_CHAR, 0, MPI_COMM_WORLD);

  mpz_class n(n_str_cstr);

  delete[] n_str_cstr; // Clean up

  mpz_class m;
  mpz_sqrt(m.get_mpz_t(), n.get_mpz_t());

  if (world_rank == 0) {
    std::cout << "Computed m (floor(sqrt(n))): " << m << "\n" << std::endl;
  }

  std::string n_serialized = n.get_str();
  std::string m_serialized = m.get_str();

  int n_len = n_serialized.size();
  int m_len = m_serialized.size();
  MPI_Bcast(&n_len, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&m_len, 1, MPI_INT, 0, MPI_COMM_WORLD);

  char *n_cstr = new char[n_len + 1];
  char *m_cstr = new char[m_len + 1];
  if (world_rank == 0) {
    std::copy(n_serialized.begin(), n_serialized.end(), n_cstr);
    n_cstr[n_len] = '\0';
    std::copy(m_serialized.begin(), m_serialized.end(), m_cstr);
    m_cstr[m_len] = '\0';
  }
  MPI_Bcast(n_cstr, n_len + 1, MPI_CHAR, 0, MPI_COMM_WORLD);
  MPI_Bcast(m_cstr, m_len + 1, MPI_CHAR, 0, MPI_COMM_WORLD);

  n = mpz_class(n_cstr);
  m = mpz_class(m_cstr);

  delete[] n_cstr;
  delete[] m_cstr;

  std::vector<int> factor_base_primes;
  std::vector<int> factor_base;

  // Step 1: Generate primes up to a certain limit
  int prime_limit = 20000; // Adjust as needed for larger numbers
  std::vector<int> primes = generatePrimes(prime_limit);

  std::vector<int> primes_filtered;
  for (const auto &p : primes) {
    if (mpz_divisible_ui_p(n.get_mpz_t(), p) == 0) {
      primes_filtered.push_back(p);
    }
  }

  for (const auto &p : primes_filtered) {
    int ls = legendreSymbol(n, p);
    if (ls == 1) {
      factor_base_primes.push_back(p);
    }
  }

  factor_base.push_back(-1);
  factor_base.insert(factor_base.end(), factor_base_primes.begin(),
                     factor_base_primes.end());

  if (world_rank == 0) {
    std::cout << "Final Factor Base (including -1):\n";
    for (const auto &p : factor_base) {
      std::cout << p << " ";
    }
    std::cout << "\n\n";
  }

  int fb_size = factor_base.size();
  MPI_Bcast(&fb_size, 1, MPI_INT, 0, MPI_COMM_WORLD);

  if (world_rank != 0) {
    factor_base.resize(fb_size);
  }
  MPI_Bcast(factor_base.data(), fb_size, MPI_INT, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);

  const int x_min = 0;
  const int x_max = 4000000; // Increase the range to collect more relations
  const int total_x = x_max - x_min + 1;

  int x_per_process = total_x / world_size;
  int remainder = total_x % world_size;

  int local_x_start, local_x_end;
  if (world_rank < remainder) {
    local_x_start = x_min + world_rank * (x_per_process + 1);
    local_x_end = local_x_start + x_per_process;
  } else {
    local_x_start = x_min + world_rank * x_per_process + remainder;
    local_x_end = local_x_start + x_per_process - 1;
  }
  if (local_x_end > x_max) {
    local_x_end = x_max;
  }

  std::vector<std::vector<int>> local_smooth_relations; // Exponent vectors
  std::vector<int> local_smooth_x; // Corresponding x values

  for (int x = local_x_start; x <= local_x_end; ++x) {
    mpz_class Qx = compute_Qx(x, m, n);
    std::vector<int> exponents = factorize_Qx(Qx, factor_base);
    if (!exponents.empty()) {
      local_smooth_relations.emplace_back(exponents);
      local_smooth_x.push_back(x);
    }
  }

  int local_count = local_smooth_relations.size();
  std::vector<int> recv_counts(world_size, 0);
  MPI_Gather(&local_count, 1, MPI_INT, recv_counts.data(), 1, MPI_INT, 0,
             MPI_COMM_WORLD);

  std::vector<int> displs(world_size, 0);
  int total_recv = 0;
  if (world_rank == 0) {
    total_recv = recv_counts[0];
    for (int i = 1; i < world_size; ++i) {
      displs[i] = displs[i - 1] + recv_counts[i - 1];
      total_recv += recv_counts[i];
    }
  }

  std::vector<int> all_smooth_x(total_recv);
  MPI_Gatherv(local_smooth_x.data(), local_count, MPI_INT, all_smooth_x.data(),
              recv_counts.data(), displs.data(), MPI_INT, 0, MPI_COMM_WORLD);

  std::vector<int> local_exponents_flat;
  for (const auto &exponents : local_smooth_relations) {
    local_exponents_flat.insert(local_exponents_flat.end(), exponents.begin(),
                                exponents.end());
  }
  int exponents_per_relation = factor_base.size();
  std::vector<int> recv_counts_exponents(world_size, 0);
  int local_exponents_count = local_exponents_flat.size();
  MPI_Gather(&local_exponents_count, 1, MPI_INT, recv_counts_exponents.data(),
             1, MPI_INT, 0, MPI_COMM_WORLD);
  std::vector<int> displs_exponents(world_size, 0);
  int total_exponents_recv = 0;
  if (world_rank == 0) {
    total_exponents_recv = recv_counts_exponents[0];
    for (int i = 1; i < world_size; ++i) {
      displs_exponents[i] =
          displs_exponents[i - 1] + recv_counts_exponents[i - 1];
      total_exponents_recv += recv_counts_exponents[i];
    }
  }
  std::vector<int> all_exponents_flat(total_exponents_recv);
  MPI_Gatherv(local_exponents_flat.data(), local_exponents_count, MPI_INT,
              all_exponents_flat.data(), recv_counts_exponents.data(),
              displs_exponents.data(), MPI_INT, 0, MPI_COMM_WORLD);

  if (world_rank == 0) {
    int num_relations = total_exponents_recv / exponents_per_relation;
    std::vector<std::vector<int>> smooth_relations(
        num_relations, std::vector<int>(exponents_per_relation));
    for (int i = 0; i < num_relations; ++i) {
      for (int j = 0; j < exponents_per_relation; ++j) {
        smooth_relations[i][j] =
            all_exponents_flat[i * exponents_per_relation + j];
      }
    }
    std::cout << "Total smooth relations found: " << num_relations << "\n"
              << std::endl;
    if (smooth_relations.empty()) {
      std::cout << "No smooth relations found. Increase the sieving range or "
                   "adjust the Factor Base."
                << std::endl;
      MPI_Finalize();
      return 0;
    }
    std::cout << "Constructing the Exponent Matrix...\n" << std::endl;
    printMatrix(smooth_relations, factor_base);
    std::cout << "Performing Gaussian Elimination over GF(2) to find "
                 "dependencies...\n"
              << std::endl;
    std::vector<std::vector<int>> matrix_mod2 = smooth_relations;
    for (auto &row : matrix_mod2) {
      for (auto &val : row) {
        val = val % 2;
      }
    }
    std::vector<std::vector<int>> dependencies =
        findDependenciesOptimized(matrix_mod2, factor_base.size());
    if (dependencies.empty()) {
      std::cout << "No dependencies found.\n" << std::endl;
    } else {
      std::cout << "Dependencies Found:\n";
      for (size_t i = 0; i < dependencies.size(); ++i) {
        std::cout << "Dependency " << i + 1 << ": ";
        for (size_t j = 0; j < dependencies[i].size(); ++j) {
          if (dependencies[i][j] == 1) {
            std::cout << "Relation " << j + 1 << " ";
          }
        }
        std::cout << "\n";
      }
      std::cout << "\n";
      std::cout << "Attempting to find factors using dependencies...\n"
                << std::endl;
      for (size_t i = 0; i < dependencies.size(); ++i) {
        mpz_class a = 1;
        mpz_class b = 1;
        std::vector<int> total_exponents(factor_base.size(), 0);
        for (size_t j = 0; j < dependencies[i].size(); ++j) {
          if (dependencies[i][j] == 1) {
            int x = all_smooth_x[j];
            mpz_class x_plus_m = x + m;
            a = (a * x_plus_m) % n;
            for (size_t k = 0; k < factor_base.size(); ++k) {
              total_exponents[k] += smooth_relations[j][k];
            }
          }
        }
        for (size_t k = 0; k < total_exponents.size(); ++k) {
          total_exponents[k] /= 2;
        }
        for (size_t k = 0; k < factor_base.size(); ++k) {
          if (total_exponents[k] > 0) {
            mpz_class temp = factor_base[k];
            mpz_class temp_pow;
            mpz_pow_ui(temp_pow.get_mpz_t(), temp.get_mpz_t(),
                       total_exponents[k]);
            b = (b * temp_pow) % n;
          }
        }
        mpz_class diff = a - b;
        if (diff < 0)
          diff += n;
        mpz_class gcd_value;
        mpz_gcd(gcd_value.get_mpz_t(), diff.get_mpz_t(), n.get_mpz_t());
        if (gcd_value > 1 && gcd_value < n) {
          mpz_class complementary_factor = n / gcd_value;
          std::cout << "Non-trivial factor found: " << gcd_value << std::endl;
          std::cout << "Complementary factor: " << complementary_factor << "\n"
                    << std::endl;
          MPI_Finalize();
          return 0;
        }
      }
      std::cout
          << "No non-trivial factors found with the current dependencies.\n"
          << std::endl;
    }
  }

  MPI_Finalize();
  return 0;
}
