import hashlib
import time
password=[]


def read_file_to_list(filename):
    try:
        with open(filename, 'r', encoding='utf-8', errors='replace') as file:
            # Read lines, strip whitespace, and store in a list
            lines = [line.strip() for line in file.readlines()]
        return lines
    except FileNotFoundError:
        print(f"Error: The file '{filename}' was not found.")
        return []
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return []
    

def hash_of_message_using_md5(word):
    
    data = word.encode('utf-8')
    md5_hash = hashlib.md5(data).hexdigest()
    return md5_hash


def hash_of_message_using_sha1(word):
   
    data = word.encode('utf-8')
    sha1_hash = hashlib.sha1(data).hexdigest()
    return sha1_hash




def hash_of_message_using_sha256(word):
    
    data = word.encode('utf-8')
    sha256_hash = hashlib.sha256(data).hexdigest()
    return sha256_hash

def hash_of_message(word):
  
    data = word.encode('utf-8')
    md5_hash = hashlib.md5(data).hexdigest()
    sha1_hash = hashlib.sha1(data).hexdigest()
    sha256_hash = hashlib.sha256(data).hexdigest()
    return md5_hash, sha1_hash, sha256_hash

def load_hashes(filename):
   

    try:
        with open(filename, 'r') as file:
            # Read all lines, strip whitespace, and store in a set
            return list(line.strip() for line in file)
    except FileNotFoundError:
        print(f"Error: The file '{filename}' was not found.")
        return set()
    except Exception as e:
        print(f"An unexpected error occurred while reading '{filename}': {e}")
        return set()
def read_file_name():
    millions_passwords_file = 'rockyou.txt'
    md5_hashes_file = 'md5_hashes.txt'
    sha1_hashes_file = 'sha1_hashes.txt'
    sha256_hashes_file = 'sha256_hashes.txt'
    output_filename = 'output.txt'
    return millions_passwords_file,md5_hashes_file,sha1_hashes_file,sha256_hashes_file,output_filename


def main():
    # Define the file names
    millions_passwords_file,md5_hashes_file,sha1_hashes_file,sha256_hashes_file,output_filename =read_file_name() 
    # millions_passwords_file = 'rockyou.txt'
    # md5_hashes_file = 'md5_hashes.txt'
    # sha1_hashes_file = 'sha1_hashes.txt'
    # sha256_hashes_file = 'sha256_hashes.txt'
    # output_filename = 'output.txt'
   
    password=read_file_to_list(millions_passwords_file)
    print("Total word in Dictionary : ",len(password))

    # Load hash lists into sets for O(1) lookup times
    md5_hashes = load_hashes(md5_hashes_file)
    sha1_hashes = load_hashes(sha1_hashes_file)
    sha256_hashes = load_hashes(sha256_hashes_file)
    # print(type(md5_hashes))
    # Initialize dictionaries to store matched hashes
    md5_matches = {}
    sha1_matches = {}
    sha256_matches = {}
   
    i=0 
    n=len(md5_hashes)
    print("\n\n..........Cryptanalysis Start for md5...........\n\n")
    start_time = time.time()
    print("Start At : ",start_time)
    while(i<n):
        for word in password:
            md5_hash=hash_of_message_using_md5(word)
            if md5_hash==md5_hashes[i]:
                md5_matches[md5_hash]=word
                break
        i=i+1
   
    end_time = time.time()
    print("End At : ",end_time)
    elapsed_time_md5 = end_time - start_time  
    print("Total Time in MD5 :",elapsed_time_md5)
    print("\n\n..........Cryptanalysis Start for sha1...........\n\n")
    
    i=0 
    n=len(sha1_hashes)
    start_time = time.time()
    print("Start At : ",start_time)


    while(i<n):
        s=0
        for word in password:
            sha1_hash=hash_of_message_using_sha1(word)
            if sha1_hash==sha1_hashes[i]:
                sha1_matches[sha1_hash]=word
                s=1
                break
        if s==0:
            not_found.append(sha1_hashes[i])
        i=i+1
    
    end_time = time.time()
    print("End At : ",end_time)
    elapsed_time_sha1 = end_time - start_time  
    print("Total Time in SHA1 : ",elapsed_time_sha1)        

    print("\n\n..........Cryptanalysis Start for sha256...........\n\n")    
    i=0 
    n=len(sha256_hashes)
    start_time = time.time()
    print("Start At : ",start_time)
    while(i<n):
        for word in password:
            sha256_hash=hash_of_message_using_sha256(word)
            if sha256_hash==sha256_hashes[i]:
                sha256_matches[sha256_hash]=word
                break
        i=i+1                 
    end_time = time.time()
    print("End At : ",end_time)
    elapsed_time_sha256 = end_time - start_time
    print("Total Time in SHA256 : ",elapsed_time_sha256)
             


 
    all_matches = {
        'MD5': md5_matches,
        'SHA1': sha1_matches,
        'SHA256': sha256_matches
    }

    # Write the matches to the output file
    try:
        with open(output_filename, 'w') as outfile:
            for hash_type, matches in all_matches.items():
                outfile.write(f"--- {hash_type} Matches ---\n")
                for hash_value, password in matches.items():
                    outfile.write(f"{hash_value}: {password}\n")
                outfile.write("\n")
        print(f"\nAll matching passwords have been written to '{output_filename}'.")
    except Exception as e:
        print(f"An error occurred while writing to '{output_filename}': {e}")

    # Optional: Print the number of matches found
    print("\nSummary of Matches Found:")
    for hash_type, matches in all_matches.items():
        print(f"{hash_type} matches: {len(matches)}")

if __name__ == "__main__":
    print("\n\n------------------------------------------------------------------------------Let's Go--------------------------------------------------------------------------------------------")
    print("\n\n-----------------------------------------------------Cryptanalysis Start for unsalted of respective algorithm MD5,SH1,SHA256------------------------------------------------------\n\n")
    main()
