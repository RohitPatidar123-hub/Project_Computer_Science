from operator import itemgetter

dis = []
diff = []
user_str = ""
Sub1 = ""
Sub2 = ""
Sub3 = ""
Sub4 = ""
Sub5 = ""
Sub_arr = []
final_keys = []


def choice_Of_operation(choice):
    match choice:
        case 1:
            plaintext_to_ciphecipherext()
        case 2:
            ciphecipherext_to_plaintext()


def plaintext_to_ciphecipherext():
    print(
        "To convert  Plaintext to cipher text you need to give Plaintext as well as their key :"
    )
    str = input("Enter Your Plaintext :")
    str = str.upper()
    key = input("Enter your key : ")
    key = key.upper()
    str_length = len(str)
    key_length = len(key)
    cipher = ""
    i = 0
    v = 0
    for i in range(0, str_length):
        if str[i] >= "A" and str[i] <= "Z":
            l = ord(str[i]) - 65
            m = ord(key[(v) % key_length]) - 65
            c = chr((l + m) % 26 + 65)
            cipher += c
            v += 1
        else:
            cipher += str[i]
    print("Your Plaintext :", str)
    print("Your Cipher text :", cipher)


def index_of_coincidence(str):
    str = str.upper()
    # print(f"In the sequence \n{str}\n")
    freq_table = []
    freq_count = 0
    freq_total = 0
    for i in range(0, 26):
        V = []
        ch = chr(65 + i)
        n = str.count(ch)
        n1 = n - 1
        total = n * n1
        V.append(ch)
        V.append(n)
        V.append(n1)
        V.append(total)
        freq_table.append(V)
        freq_count = freq_count + n
        freq_total = freq_total + total
    V = []
    V.append("Total")
    V.append(freq_count)
    V.append("Null")
    V.append(freq_total)
    freq_table.append(V)
    # for i in freq_table:
    #    print(i)
    IC1 = freq_total / freq_count
    IC = IC1 / (freq_count - 1)
    return IC


def decrypt(cipher, key):
    decrypted_text = []
    key_length = len(key)
    key_as_int = [ord(i) for i in key]
    cipher_as_int = [ord(i) for i in cipher]

    for i in range(len(cipher_as_int)):
        value = (
            cipher_as_int[i] - key_as_int[i % key_length]
        ) % 26  # mod with key to repeat it
        decrypted_text.append(chr(value + ord("A")))

    ic = index_of_coincidence("".join(decrypted_text))
    # print("******************in decrypt**************************")
    return abs(ic - 0.068)


def decrypt_plain(key, cipher):
    decrypted_text = []
    key_length = len(key)
    key_as_int = [ord(i) for i in key]
    cipher_as_int = [ord(i) for i in cipher]

    for i in range(len(cipher_as_int)):
        value = (
            cipher_as_int[i] - key_as_int[i % key_length]
        ) % 26  # mod with key to repeat it
        decrypted_text.append(chr(value + ord("A")))

    return "".join(decrypted_text)


def print_key_plaintext():
    global final_keys
    global user_str
    for key in final_keys:
        PLAINTEXT = decrypt_plain(key, user_str)
        print(f"Key: {key}\nPlaintext :{PLAINTEXT}\n")


def generate_subsequence():
    global user_str
    global Sub_arr
    global answer
    global final_keys
    ## print("in subsequence")

    sub2_1 = user_str[::2]
    sub2_2 = user_str[1::2]
    sub3_1 = user_str[::3]
    sub3_2 = user_str[1::3]
    sub3_3 = user_str[2::3]
    sub4_1 = user_str[::4]
    sub4_2 = user_str[1::4]
    sub4_3 = user_str[2::4]
    sub4_4 = user_str[3::4]
    sub5_1 = user_str[::5]
    sub5_2 = user_str[1::5]
    sub5_3 = user_str[2::5]
    sub5_4 = user_str[3::5]
    sub5_5 = user_str[4::5]

    IC_sub2_1 = index_of_coincidence(sub2_1)
    IC_sub2_2 = index_of_coincidence(sub2_2)
    IC_sub3_1 = index_of_coincidence(sub3_1)
    IC_sub3_2 = index_of_coincidence(sub3_2)
    IC_sub3_3 = index_of_coincidence(sub3_3)
    IC_sub4_1 = index_of_coincidence(sub4_1)
    IC_sub4_2 = index_of_coincidence(sub4_2)
    IC_sub4_3 = index_of_coincidence(sub4_3)
    IC_sub4_4 = index_of_coincidence(sub4_4)
    IC_sub5_1 = index_of_coincidence(sub5_1)
    IC_sub5_2 = index_of_coincidence(sub5_2)
    IC_sub5_3 = index_of_coincidence(sub5_3)
    IC_sub5_4 = index_of_coincidence(sub5_4)
    IC_sub5_5 = index_of_coincidence(sub5_5)

    IC_2 = (IC_sub2_1 + IC_sub2_2) / 2
    IC_3 = (IC_sub3_1 + IC_sub3_2 + IC_sub3_3) / 3
    IC_4 = (IC_sub4_4 + IC_sub4_3 + IC_sub4_2 + IC_sub4_1) / 4
    IC_5 = (IC_sub5_5 + IC_sub5_4 + IC_sub5_3 + IC_sub5_2 + IC_sub5_1) / 5
    print(f"IC_sub2_1: {IC_sub2_1}\nIC_sub2_2: {IC_sub2_2}\n")
    print(f"IC_sub3_1: {IC_sub3_1}\nIC_sub3_2: {IC_sub3_2}\nIC_sub3_3: {IC_sub3_3}\n")
    print(
        f"IC_sub4_1: {IC_sub4_1}\nIC_sub4_2: {IC_sub4_2}\nIC_sub4_3: {IC_sub4_3}\nIC_sub4_4: {IC_sub4_4}\n"
    )
    print(
        f"IC_sub5_1: {IC_sub5_1}\nIC_sub5_2: {IC_sub5_2}\nIC_sub5_3: {IC_sub5_3}\nIC_sub5_4: {IC_sub5_4}\nIC_sub5_5: {IC_sub5_5}\n"
    )

    print(f"IC 2 is {IC_2}\n")
    print(f"IC 3 is {IC_3}\n")
    print(f"IC 4 is {IC_4}\n")
    print(f"IC 5 is {IC_5}\n")

    abs_IC_2 = abs(IC_2 - 0.068)
    abs_IC_3 = abs(IC_3 - 0.068)
    abs_IC_4 = abs(IC_4 - 0.068)
    abs_IC_5 = abs(IC_5 - 0.068)

    if abs_IC_2 <= abs_IC_3 and abs_IC_2 <= abs_IC_4 and abs_IC_2 <= abs_IC_5:
        Sub_arr.extend([sub2_1, sub2_2])
        print("IC_2 is the smallest")
    elif abs_IC_3 <= abs_IC_2 and abs_IC_3 <= abs_IC_4 and abs_IC_3 <= abs_IC_5:
        Sub_arr.extend([sub3_1, sub3_2, sub3_3])
        print("IC_3 is the smallest")
    elif abs_IC_4 <= abs_IC_2 and abs_IC_4 <= abs_IC_3 and abs_IC_4 <= abs_IC_5:
        Sub_arr.extend([sub4_1, sub4_2, sub4_3, sub4_4])
        print("IC_4 is the smallest")
    else:
        Sub_arr.extend([sub5_1, sub5_2, sub5_3, sub5_4, sub5_5])
        print("IC_5 is the smallest")

    result = []
    #   print(string)
    print(f"{len(Sub_arr)}")
    for sub in Sub_arr:
        frequency_count = {}
        # print(sub)

        for char in sub:
            if char in frequency_count:
                frequency_count[char] += 1
            else:
                frequency_count[char] = 1

        max_frequency = 0
        most_frequent_char = ""

        for char, count in frequency_count.items():
            if count > max_frequency:
                max_frequency = count
                most_frequent_char = char

        result.append(most_frequent_char)

    print(f"{result}")
    length = len(result)
    max = ["E", "T", "A", "O", "I", "N", "S"]
    min_ic_list = []
    match length:
        case 2:
            for i in max:
                for j in max:
                    key = ""
                    s1 = (ord(result[0]) - ord(i)) % 26
                    s2 = (ord(result[1]) - ord(j)) % 26
                    key = key + chr(ord("A") + s1) + chr(ord("A") + s2)
                    min_ic_list.append([decrypt(user_str, key), key])

        case 3:
            min_ic_list = []
            for i in max:
                for j in max:
                    for k in max:
                        key = ""
                        s1 = (ord(result[0]) - ord(i)) % 26
                        s2 = (ord(result[1]) - ord(j)) % 26
                        s3 = (ord(result[2]) - ord(k)) % 26
                        key = (
                            key
                            + chr(ord("A") + s1)
                            + chr(ord("A") + s2)
                            + chr(ord("A") + s3)
                        )
                        min_ic_list.append([decrypt(user_str, key), key])

        case 4:
            for i in max:
                for j in max:
                    for k in max:
                        for l in max:
                            key = ""
                            s1 = (ord(result[0]) - ord(i)) % 26
                            s2 = (ord(result[1]) - ord(j)) % 26
                            s3 = (ord(result[2]) - ord(k)) % 26
                            s4 = (ord(result[3]) - ord(l)) % 26
                            key = (
                                key
                                + chr(ord("A") + s1)
                                + chr(ord("A") + s2)
                                + chr(ord("A") + s3)
                                + chr(ord("A") + s4)
                            )
                            min_ic_list.append([decrypt(user_str, key), key])

        case 5:
            for i in max:
                for j in max:
                    for k in max:
                        for l in max:
                            for m in max:
                                key = ""
                                s1 = (ord(result[0]) - ord(i)) % 26
                                s2 = (ord(result[1]) - ord(j)) % 26
                                s3 = (ord(result[2]) - ord(k)) % 26
                                s4 = (ord(result[3]) - ord(l)) % 26
                                s5 = (ord(result[4]) - ord(m)) % 26
                                key = (
                                    key
                                    + chr(ord("A") + s1)
                                    + chr(ord("A") + s2)
                                    + chr(ord("A") + s3)
                                    + chr(ord("A") + s4)
                                    + chr(ord("A") + s5)
                                )
                                min_ic_list.append([decrypt(user_str, key), key])

    min_ic_list.sort()
    ##print(f"***************************************min_ic_list")
    min_ic_list.sort(key=itemgetter(0))

    for i in range(min(10, len(min_ic_list))):
        print(f"Value: {min_ic_list[i][0]}, Key: {min_ic_list[i][1]}")
        final_keys.append(min_ic_list[i][1])
    # key=min_ic_list[0][1]
    print_key_plaintext()


def ciphecipherext_to_plaintext():
    global user_str
    print("To convert Ciphertext to plaintext you need to give cipher text")
    user_input = input("Enter Your cipher text :")
    user_str = "".join(filter(str.isalpha, user_input)).upper()
    generate_subsequence()


def freq_of_factor_length_of_key():

    global dis
    global diff
    str = input("Enter cipher text")
    frequency = []
    for i in range(2, 20):
        frequency.append([i, 0])

    def position(substr):
        index = 0
        d = []
        d1 = []
        d1.append(substr)
        d.append(substr)
        for i in range(str.count(substr)):
            index = str.find(substr, index)
            d.append(index)
            index = index + len(substr)
        dis.append(d)
        l = len(d)
        i = 1
        while i < l - 1:
            j = i + 1
            while j < l:
                d1.append(d[j] - d[i])
                j = j + 1
            i = i + 1
        diff.append(d1)

    # arr1 = []      ##contain frequency of singe letter
    # for i in range(26):
    #         substr = "" + chr(i + 65)  + ""     # X
    #         if str.count(substr) > 1:
    #             arr1.append(0, ( str.count(substr), substr))

    # arr1.sort(reverse=True)
    # print("Frequency Of Single Character in Cypecipherext:\n",arr1)

    arr2 = []
    for i in range(26):
        for j in range(26):
            substr = "" + chr(i + 65) + chr(j + 65) + ""  # XY
            if str.count(substr) > 1:
                arr2.append(0, (str.count(substr), substr))
                position(substr)

    arr2.sort(reverse=True)
    print("\n\nFrequency Of digraphs in Cypecipherext:\n", arr2)

    arr3 = []
    for i in range(26):
        for j in range(26):
            for k in range(26):
                substr = "" + chr(i + 65) + chr(j + 65) + chr(k + 65) + ""  # XYZ
                if str.count(substr) > 1:
                    arr3.append(0, (str.count(substr), substr))
                    position(substr)
    arr3.sort(reverse=True)
    print("\n\nFrequency Of trigraph 3 letter  in Cypecipherext:\n", arr3)
    arr4 = []  ##contain frequency of 4 length word
    for i in range(26):
        for j in range(26):
            for k in range(26):
                for l in range(26):
                    substr = (
                        "" + chr(i + 65) + chr(j + 65) + chr(k + 65) + chr(l + 65) + ""
                    )  # ABCD
                    if str.count(substr) > 1:
                        arr4.append(0, (str.count(substr), substr))
                        position(substr)

    arr4.sort(reverse=True)
    print("\n\nFrequency Of 4 letter word in Cypecipherext:\n", arr4)

    print("dis = ", dis)
    print("diff", diff)
    for i in diff:
        j = 1
        while j < len(i):
            for k in range(2, 20):
                if i[j] % k == 0:
                    frequency[k - 2][1] += 1
            j = j + 1
    ##print("frequency of factor:", frequency)


if __name__ == "__main__":

    print("1.From Plaintext to Cipher text")
    print("2. From Ciphertext to Plaintext")
    choice = int(input("Please Enter input Choice[1,2]:"))
    choice_Of_operation(choice)
