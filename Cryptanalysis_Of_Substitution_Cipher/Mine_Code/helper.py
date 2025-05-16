import copy
import re 
import pprint
from collections import defaultdict
from spellchecker import SpellChecker


escape_char=[',' , '.' , ' ' , '"','\'','!',';']
cipher_text1="1981y, $pp1n1yuux oq@ 2@3s5u1n $p 1981y, 1v y n$s9o2x 19 v$soq yv1y. 1o 1v oq@ v@6@9oq uy27@vo n$s9o2x 5x y2@y, oq@ v@n$98 0$vo 3$3su$sv n$s9o2x, y98 oq@ 0$vo 3$3su$sv 8@0$n2ynx 19 oq@ #$2u8. 5$s98@8 5x oq@ 1981y9 $n@y9 $9 oq@ v$soq, oq@ y2y51y9 v@y $9 oq@ v$soq#@vo, y98 oq@ 5yx $p 5@97yu $9 oq@ v$soq@yvo, 1o vqy2@v uy98 5$28@2v #1oq 3yw1voy9 o$ oq@ #@vo; nq19y, 9@3yu, y98 5qsoy9 o$ oq@ 9$2oq; y98 5y97uy8@vq y98 0xy90y2 o$ oq@ @yvo. 19 oq@ 1981y9 $n@y9, 1981y 1v 19 oq@ 61n191ox $p v21 uy9wy y98 oq@ 0yu816@v; 1ov y98y0y9 y98 91n$5y2 1vuy98v vqy2@ y 0y21o10@ 5$28@2 #1oq oqy1uy98, 0xy90y2 y98 198$9@v1y. 7$$8, 9$# os29 p$2 oq@ v@n$98 3y2o $p oq@ 4s@vo1$9, 7$$8 usnw!"
cipher_text2="64s48u46 8y6 q480ryp nrv 6ryy43 2yu$2tn46, n4 54yu u$ o46. un8u yrpnu n4 6r6 y$u vq441 54qq, n80ryp s4043rvn 6348wv, n80ryp y$ 34vu. n4 58v 2yv234 5n4un43 n4 58v 8vq441 $3 6348wryp. t$yvtr$2v, 2yt$yvtr$2v, 8qq 58v 8 oq23. n4 34w4wo4346 t3#ryp, 5rvnryp, n$1ryp, o4ppryp, 404y q82pnryp. n4 sq$8u46 un3$2pn un4 2yr043v4, v44ryp vu83v, 1q8y4uv, v44ryp 483un, 8qq o2u nrwv4qs. 5n4y n4 q$$z46 6$5y, u3#ryp u$ v44 nrv o$6#, un434 58v y$unryp. ru 58v x2vu un8u n4 58v un434, o2u n4 t$2q6 y$u s44q 8y#unryp s$3 x2vu nrv 134v4yt4."
ciphertext=cipher_text2
nonLettersOrSpacePattern = re.compile(r'[^1234567890@#^$A-Z\s]')
nonLettersOrSpacePatternwith_ = re.compile(r'[^1234567890-@#^$A-Z\s]')
# def getplaincipherletterignore(cipherletterToPlaintextMapping,ciphertext)--> this will return cipher letter that we neet to ignore
# def getDifferentCipherLetter(ciphertext) : --> return different cipher letter
# def getDifferentPlaintextLetter(plaintext) :-->return differnt plaintext
# def getBlankCipherletterMapping(ciphertext):--> return blank mapping of cipher for  possible combination but initially it is emply
# def getCipherWord(ciphertext):-> return word of cipher text
# def getPlainWords(plaintext): -->return word of plaintext
# def getWordPattern(word):-->return word pattern
# def getAllWordPattern():---> it return all word pattern in dictionary format
# def getMappingFromCipherwordToCandidateword(letterMapping, cipherword, candidate):
# def intersectMappings(mapA, mapB,ciphertext):--> return intersectedMapping=mapA and mapB
# def removeSolvedLettersFromIntersectMapping(intersectedMap): -->this remove solved ciphertext mapping 's plain letter from other cipher letter
# def decryptFromCiphertextToPlaintext(ciphertext,cipherLetterToPlaintextMapping) --> this decrypt into plaintext from using mapping from cipher text to plaintext
# def getBlankPlainletterMapping():-->return bland maping for plainletter to cipherletter
# def getMappingFromPlainwordToCipherword(plaintext,ignoreplainletter,plainletterToCiperletterMapping,ciphertext,cipherletterToPlaintextMapping)-->return maping from plainword to cipherword
# def getMappingFromPlainlettersToCipherletters(cipherletterToPlainletterMapping,ignoreplainletter): return maping from plaintletter to ciphertext
# def getMappingFromCipherwordToPlainword(cipherword,) --->return mapping from cipher word to plain word
# def getMappingFromPlainwordToCipherword(plainword,) ---> return mapping from plain word to cipher word 
# def frequency_Of_Char(str):-->retrun frequency of char
# def getRemaingCipherLetter(ciphertext,cipherLetterToPlaintextMapping)--> return remaing cipher text that is not matched to any one
# def getRemaingPlaintextLetter(plaintext)---> return remaing plaintext letter
# def getDictionary()-->return dictionary word
# def getSplitSemiPlaintext(plaintext): --> return split word from plaintext that contain -
# def redefineCipherletterToPlaintextMapping(plaintext,ciphertext,cipherletterToPlaintextMapping,plainletterToCiperletterMapping)--> return cipherlettertoplainletter mapping
# def getPossibleWordPatter(word):-->return posible plaintext word
# def spellCheck(wordList):-->return corrected word list
# def spellCheckerAndUpdateAll(plaintext,ciphertext,cipherletterToPlaintextMapping,plainletterToCiperletterMapping,MappingFromCipherwordToPlainword,MappingFromPlainwordToCipherword)--> return plaintext , cipherletterToPlaintextMapping , plainletterToCiperletterMapping , MappingFromCipherwordToPlainword , MappingFromPlainwordToCipherword =
    
def getplainletterignore(cipherletterToPlaintextMapping,ciphertext):
    ignorecipherletter=''
    done=''
    ALPHABET=(getDifferentCipherLetter(ciphertext)).upper()
    for i in ALPHABET:
        
        if len(cipherletterToPlaintextMapping[i])==1:
            if cipherletterToPlaintextMapping[i][0] not in done:
                done =done + cipherletterToPlaintextMapping[i][0]
            else :
                ignorecipherletter=ignorecipherletter+str(cipherletterToPlaintextMapping[i])
    
    return ignorecipherletter           



def getDictionary():

    with open('Dictionary.txt') as f:
        wordList = f.read().splitlines()
    return wordList    


def getDifferentCipherLetter(ciphertext) :   
    
    LETTERS=''
    for i in ciphertext:
        if i not in escape_char:
                if i not in LETTERS:
                    LETTERS=LETTERS+i
    return LETTERS

def getDifferentPlaintextLetter(plaintext) :   
    
    LETTERS=''
    for i in plaintext:
        if i not in escape_char:
                if i not in LETTERS:
                    LETTERS=LETTERS+i
    return LETTERS

# cipherLetter=getDifferentCipherLetter(ciphertext)
# print(cipherLetter," : ",len(cipherLetter),"\n")


def getBlankCipherletterMapping(ciphertext):

    cipherLetter=getDifferentCipherLetter(ciphertext)
    cipherLetter=cipherLetter.upper()             
    return {letter: [] for letter in cipherLetter}

# blankMapping=getBlankCipherletterMapping(ciphertext)
# print(blankMapping," ",len(blankMapping),"\n")


def getCipherWords(ciphertext):
     cipherwordList = nonLettersOrSpacePattern.sub('', ciphertext.upper()).split()
     return cipherwordList

def getPlainWords(plaintext):
    nonLettersOrSpacePatternwith_ = re.compile(r'[^A-Z -]')
    plainwordList = nonLettersOrSpacePatternwith_.sub('', plaintext.upper()).split()
    return plainwordList



def getWordPattern(word):
    # Returns a string of the word pattern
    # Example: "puppy" -> "0.1.0.0.2"
    nextNum = 0
    letterNums = {}
    wordPattern = []
    
    for char in word:
        if char not in letterNums:
            letterNums[char] = str(nextNum)
            nextNum += 1
        wordPattern.append(letterNums[char])
    return '.'.join(wordPattern)

# print(getWordPattern("8@0$N2YNX"))
# print(getWordPattern("ROH232323T"))


def getAllWordPattern():
    
    # this function get all pattern of word and make a file allWordpatterns.py and also return in dictioary form
    allPatterns = {}
    with open('Dictionary.txt') as f:
        wordList = f.read().splitlines()
        
    for word in wordList:
        word = word.upper()  # store in uppercase
        pattern = getWordPattern(word)
        
        if pattern not in allPatterns:
            allPatterns[pattern] = [word]
        else:
            allPatterns[pattern].append(word)
    
    with open('allWordPatterns.py', 'w') as outFile:
        outFile.write('allPatterns = ')
        outFile.write(pprint.pformat(allPatterns))
    return allPatterns  

# allPatterns=getAllWordPattern()
# print(allPatterns,":",len(allPatterns))

def getMappingFromCipherwordToCandidateword(letterMapping, cipherword, candidate):
    
    # this function return mapping from cipherword to candidateword
    for i in range(len(cipherword)):
        if candidate[i] not in letterMapping[cipherword[i]]:
             letterMapping[cipherword[i]].append(candidate[i])



def getIntersectMappings(mapA, mapB, ciphertext):
    ## this function intersect only potential plaintext letter
    intersectedMapping = getBlankCipherletterMapping(ciphertext)
    ALPHABET=getDifferentCipherLetter(ciphertext)
    ALPHABET=ALPHABET.upper()
    
    for letter in ALPHABET:
        # If one mapping is empty, copy the other entirely
        if mapA[letter] == []:
            intersectedMapping[letter] = copy.deepcopy(mapB[letter])
        elif mapB[letter] == []:
            intersectedMapping[letter] = copy.deepcopy(mapA[letter])
        else:
            # Only the letters in both
            for mappedLetter in mapA[letter]:
                if mappedLetter in mapB[letter]:
                    intersectedMapping[letter].append(mappedLetter) 
    return intersectedMapping

def removeSolvedLettersFromIntersectMapping(map,ciphertext):


    ALPHABET=getDifferentCipherLetter(ciphertext)   # once cipherLetter Map to one phali letter it rmove from another cipher letter's dictionary
    ALPHABET=ALPHABET.upper()
    loopAgain = True
    while loopAgain:
        loopAgain = False
        solvedLetters = []
        # Find all letters that have exactly one mapping possibility
        for cipherletter in ALPHABET:
            if len(map[cipherletter]) == 1:
                solvedLetters.append(map[cipherletter][0])

        # Remove these solved letters from other lists
        for cipherletter in ALPHABET:
            for s in solvedLetters:
                if len(map[cipherletter]) != 1 and s in map[cipherletter]:
                    map[cipherletter].remove(s)
                    if len(map[cipherletter]) == 1:
                        loopAgain = True
                      
    return map



    
def decryptFromCiphertextToPlaintext(ciphertext,ignoreplainletter,cipherLetterToPlaintextMapping) :

    ciphertext=ciphertext.upper()
    plaintext=""
    for i in ciphertext:
        if i in escape_char:
            plaintext=plaintext+i
        elif len(cipherLetterToPlaintextMapping[i])==1 and str(cipherLetterToPlaintextMapping[i][0]) in ignoreplainletter:
             plaintext=plaintext+"-"    
        elif len(cipherLetterToPlaintextMapping[i])==1:
             plaintext=plaintext+str(cipherLetterToPlaintextMapping[i][0])
        else :
             plaintext=plaintext+"-"
    return plaintext  

def getBlankPlainletterMapping():

    plainletter="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return {letter: [] for letter in plainletter}


def getMappingFromPlainlettersToCipherletters(cipherletterToPlainletterMapping,ignoreplainletter):
    
    plainlettertoCipherletterMapping=getBlankPlainletterMapping()
    for i in cipherletterToPlainletterMapping:
        if(len(cipherletterToPlainletterMapping[i])==1   ): #"""cipherletterToPlainletterMapping[i][0] not in ignoreplainletter"""
            key = cipherletterToPlainletterMapping[i][0]
            plainlettertoCipherletterMapping[key].append(i)
    return plainlettertoCipherletterMapping



def frequency_Of_Char(str):
    # print("In Function Frequency_OF_Char:\n",str," : ",len(str),"\n")
    frequency_of_char={} #dictionary for frequency count
    for i in str : #count frequency of each character 
        if i in escape_char:
            continue
        elif i in frequency_of_char :
          frequency_of_char[i]=frequency_of_char[i]+1
        else :
          frequency_of_char[i]=1
    
    # print("Before Sorting : ")
    # print(frequency_of_char.keys())
    # print(frequency_of_char.values(),"\n\n")
    #sorted_char_count  = dict(sorted(frequency_of_char.items(), key=lambda item: item[1],reverse=True))
    #print("Frequency of character in increasing order : ",sorted_char_count)      

    return frequency_of_char

def getRemaingCipherLetter(ciphertext,cipherLetterToPlaintextMapping):
    ciphertext=ciphertext.upper()
    remaingCipherLetter=""
    
    for i in ciphertext:
        if i in escape_char:
            continue
        elif len(cipherLetterToPlaintextMapping[i])==1:
            continue
        else :
            if i not in remaingCipherLetter :
                remaingCipherLetter=remaingCipherLetter+i
    return remaingCipherLetter            

             
def getRemaingPlaintextLetter(plaintext):
        
        ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        getRemaingPlaintextLetter =""
        for i in ALPHABET:
            if i not in plaintext:
                if i not in getRemaingPlaintextLetter : 
                   getRemaingPlaintextLetter=getRemaingPlaintextLetter+i  
        return getRemaingPlaintextLetter




def propagateMapping(currentMapping, ciphertext):
    """
    Repeatedly call removeSolvedLettersFromIntersectMapping to propagate constraints.
    """
    newMapping = removeSolvedLettersFromIntersectMapping(currentMapping, ciphertext)
    return newMapping

def loadDictionary(dictPath):
    """
    Loads dictionary words from a file and returns a set of words (uppercase).
    """
    try:
        with open(dictPath) as f:
            words = f.read().splitlines()
        return set(word.upper() for word in words)
    except FileNotFoundError:
        print("Dictionary file not found.")
        return set()

def scoreDecryption(plaintext, dictionary):
    """
    Scores plaintext by counting the fraction of words found in the dictionary.
    """
    words = plaintext.split()
    if not words:
        return 0
    valid = sum(1 for w in words if w in dictionary)
    return valid / len(words)

def isMappingComplete(mapping):
    """
    Returns True if every cipher letter has exactly one candidate.
    """
    return all(len(v) == 1 for v in mapping.values())

def selectAmbiguousLetter(mapping):
    """
    Selects the cipher letter with more than one candidate and minimal ambiguity.
    """
    ambiguous = {letter: candidates for letter, candidates in mapping.items() if len(candidates) > 1}
    if not ambiguous:
        return None
    # Choose the letter with the smallest candidate list:
    return min(ambiguous, key=lambda k: len(ambiguous[k]))

# def getInitialMapping(ciphertext):
#     """
#     Gets an initial mapping using your intersect functions.
#     """
#     return getCipherLetterToPlaintextMapping(ciphertext)

def solveMapping(currentMapping, ciphertext,ignoreplainletter ,dictionary):
    # Propagate constraints.
    newMapping = propagateMapping(currentMapping, ciphertext)
    plaintext = decryptFromCiphertextToPlaintext(ciphertext,ignoreplainletter ,newMapping)
    score = scoreDecryption(plaintext, dictionary)
    
    # If score is high or mapping is complete, return mapping.
    if score >= 0.95 or isMappingComplete(newMapping):
        return newMapping

    ambiguousLetter = selectAmbiguousLetter(newMapping)
    if ambiguousLetter is None:
        return newMapping
    bestMapping = None
    bestScore = 0

    for candidate in newMapping[ambiguousLetter]:
        candidateMapping = copy.deepcopy(newMapping)
        candidateMapping[ambiguousLetter] = [candidate]

        resultMapping = solveMapping(candidateMapping, ciphertext,ignoreplainletter, dictionary)
        if resultMapping is not None:
            candidatePlaintext = decryptFromCiphertextToPlaintext(ciphertext,ignoreplainletter ,resultMapping)
            candidateScore = scoreDecryption(candidatePlaintext, dictionary)
            if candidateScore > bestScore:
                bestScore = candidateScore
                bestMapping = resultMapping

    return bestMapping

def getLargestWordFromPlaintext(wordsOfSemiPlaintext):
        
        size=0
        largestWord=''
        for i in wordsOfSemiPlaintext:
            if '-' in i  and i.count('-')==1 and len(i)>size :
               largestWord=i
               size=len(i)       
        return largestWord       

                      


def getSplitSemiPlaintext(plaintext):
    # this function return list which contain independent word from semi-plaintext 
    valid_words = re.findall(r"[A-Za-z-]+", plaintext)
    
    return valid_words



def getmapWordFromLargestToSmall(words):
        """This function return dictionary where ket is int and value is set of string """
        # Build the nested dictionary.
        # Outer key: number of hyphens in the word.
        # Inner key: length of the word.
        # Value: list of words matching the criteria.
        word_dict = defaultdict(lambda: defaultdict(list))  ## # of hyphen , length of letter , set 
        for word in words:
            hyphen_count = word.count('-')
            word_length = len(word)
            word_dict[hyphen_count][word_length].append(word)

        # Create a new sorted dictionary.
        # Outer keys (hyphen counts) will be sorted in ascending order.
        # Inner keys (word lengths) will be sorted in descending order.
        word_dict_sorted = {}
        for hyphen_count in sorted(word_dict.keys()):
            inner_dict_sorted = {}
            for word_length in sorted(word_dict[hyphen_count].keys(), reverse=True):
                inner_dict_sorted[word_length] = word_dict[hyphen_count][word_length]
            word_dict_sorted[hyphen_count] = inner_dict_sorted
        
        return word_dict_sorted        




def find_matches(clue="_UST", dictionary_file='Dictionary.txt'):
    """
    Given a clue word with exactly one missing letter (represented by a hyphen '-'),
    search through the dictionary file for words that match when the hyphen is replaced
    by any one letter.
    
    :param clue: The clue string (e.g., 'TRANSLAT-NG')
    :param dictionary_file: Path to the dictionary file (one word per line)
    :return: A list of matching words.
    """
    # Build a regex pattern: escape all characters, then replace the hyphen with a pattern for one letter
    # Using '^' and '$' to ensure full-word matches.
    regex_pattern = '^' + re.escape(clue).replace(r'\-', '[A-Za-z]') + '$'
    pattern = re.compile(regex_pattern, re.IGNORECASE)  # re.IGNORECASE for case-insensitive matching

    matching_words = []
    with open(dictionary_file, 'r') as file:
        for line in file:
            word = line.strip()
            if pattern.match(word):
                matching_words.append(word)  
                         
    return matching_words

def getMappingFromCipherwordToPlainword(ciphertext,ignoreplainletter,cipherletterToPlaintextMapping):
   # # return mapping from cipher word to plain word
    MappingFromCipherwordToPlainword={}
    cipherwordLists=getCipherWords(ciphertext)
    for word in cipherwordLists:
        plainword=''
        word=word.upper()
        for c in word:
            if len(cipherletterToPlaintextMapping[c])==1:
                str=cipherletterToPlaintextMapping[c][0]
            if len(cipherletterToPlaintextMapping[c])==1 and str not in ignoreplainletter:
                plainword=plainword + cipherletterToPlaintextMapping[c][0]
            else :
                plainword=plainword +'-'
        MappingFromCipherwordToPlainword[word]= plainword
    return  MappingFromCipherwordToPlainword 


def getMappingFromPlainwordToCipherword(plaintext,ignoreplainletter,plainletterToCiperletterMapping,ciphertext,cipherletterToPlaintextMapping):
     # return mapping from plain word to cipher word
    MappingFromCipherwordToPlainword= getMappingFromCipherwordToPlainword(ciphertext,ignoreplainletter,cipherletterToPlaintextMapping)
    mapping_plain_to_cipher = {}
    for cipher_word, plain_word in MappingFromCipherwordToPlainword.items():
        # print(cipher_word, plain_word)
        mapping_plain_to_cipher[plain_word] = cipher_word
    return mapping_plain_to_cipher


def find_letter_differences(wrong, correct):
    """
    Compare the two words letter by letter and return a list of differences.
    
    Each difference is a tuple: (position, letter_in_wrong, letter_in_correct)
    """
    differences = []
    # Compare up to the length of the shorter word
    min_length = min(len(wrong), len(correct))
    for i in range(min_length):
        if wrong[i] != correct[i]:
            differences.append((i, wrong[i], correct[i]))
            
    # If one word is longer than the other, record the extra letters as differences.
    if len(wrong) > len(correct):
        for i in range(min_length, len(wrong)):
            differences.append((i, wrong[i], None))
    elif len(correct) > len(wrong):
        for i in range(min_length, len(correct)):
            differences.append((i, None, correct[i]))
            
    return differences


def remove_duplicates(mapping):
    """
    Given a dictionary where each value is a list,
    remove duplicate items from each list, preserving the original order.
    """
    for key, letters in mapping.items():
        # Use dict.fromkeys() to preserve order while removing duplicates.
        mapping[key] = list(dict.fromkeys(letters))
    return mapping
def redefineCipherletterToPlaintextMapping(plaintext,ciphertext,ignoreplainletter,cipherletterToPlaintextMapping,plainletterToCiperletterMapping):
        newCipherletterToPlaintextMapping=getBlankCipherletterMapping(ciphertext)
        wordList=getSplitSemiPlaintext(plaintext)
        #print("word with -",wordList)
        word_dict_sorted=getmapWordFromLargestToSmall(wordList)
        # print("\n\n\n",word_dict_sorted)
        matching_words_from_semiplaintext_to_plaintext={}  # key is of string and value is of list
        for hyphen_count in word_dict_sorted:
            if(hyphen_count>0):
                #print(f"Hyphen Count: {hyphen_count}")
                inner_dict = word_dict_sorted[hyphen_count]
                # Iterate over the inner keys (word length) which are already sorted in descending order.
                for word_length in inner_dict:
                    words = inner_dict[word_length]
                    for i in words:
                        matching_words=find_matches(i)
                        matching_words_from_semiplaintext_to_plaintext[i]= matching_words
                    #print(f"  Word Length: {word_length} -> Words: {words}")
        # print("\n\n\n",matching_words_from_semiplaintext_to_plaintext)
        MappingFromCipherwordToPlainword   = getMappingFromCipherwordToPlainword(ciphertext,ignoreplainletter,cipherletterToPlaintextMapping)
        MappingFromPlainwordToCipherword   = getMappingFromPlainwordToCipherword(plaintext,ignoreplainletter,plainletterToCiperletterMapping,ciphertext,cipherletterToPlaintextMapping)        
        # print("MappingFromCipherwordToPlainword : ",MappingFromCipherwordToPlainword)
        # print("MappingFromPlainwordToCipherword: ",MappingFromPlainwordToCipherword)
        # print("cipherletterToPlaintextMapping : ",cipherletterToPlaintextMapping)
        # print("plainletterToCiperletterMapping: ",plainletterToCiperletterMapping)
        count=1
        word_list_correct_incorrect={}
        for key, value in matching_words_from_semiplaintext_to_plaintext.items():
                if len(value)==1:
                    
                    i=0
                    n=len(key)
                    str=''
                    plainword=value[0]
                    cipherword=MappingFromPlainwordToCipherword[key]
                    while(i<n):
                        if '-' ==key[i]: #key is also semi plain word
                            str=str+cipherword[i]
                        else:    
                            str=str+plainword[i]
                        i=i+1    
                    #print(key," ",plainword," ",str )
                    word_list_correct_incorrect[plainword]=str ##plainword semi plainword
        # print(word_list_correct_incorrect)
        for key ,value in word_list_correct_incorrect.items():
             #print(key,"  " ,value)
            diff = find_letter_differences(key, value) # return pos , correct ,incorrect letter
            for pos, plain_char, cipher_char in diff :
                # print(pos," ",plain_char," ",cipher_char)

                # Append directly to the list
                newCipherletterToPlaintextMapping[cipher_char]=[]
                newCipherletterToPlaintextMapping[cipher_char]=[plain_char]
                plainletterToCiperletterMapping[plain_char]=[]
                plainletterToCiperletterMapping[plain_char]=[cipher_char]

                # newCipherletterToPlaintextMapping[cipher_char]=[plain_char]
                
        
        # print("cipherletterToPlaintextMapping : ",cipherletterToPlaintextMapping)
        # print("plainletterToCiperletterMapping: ",plainletterToCiperletterMapping)
        cipherletterToPlaintextMapping=getIntersectMappings(newCipherletterToPlaintextMapping,cipherletterToPlaintextMapping,ciphertext)
        cipherletterToPlaintextMapping=removeSolvedLettersFromIntersectMapping(cipherletterToPlaintextMapping,ciphertext)
        # print(cipherletterToPlaintextMapping)
        ignoreplainletter=getplainletterignore(cipherletterToPlaintextMapping,ciphertext)
        plainletterToCiperletterMapping =getMappingFromPlainlettersToCipherletters(cipherletterToPlaintextMapping,ignoreplainletter)
        plaintext=decryptFromCiphertextToPlaintext(ciphertext,ignoreplainletter,cipherletterToPlaintextMapping)
        # print(plaintext)
        

                     


            

                        
        # print(matching_words_from_semiplaintext_to_plaintext)
                       
        return cipherletterToPlaintextMapping



def spellChecker(plaintext):
        spell = SpellChecker()
        sentence= "INDIA, OFFICIALLH THE REPU-LIC OF INDIA, IS A COUNTRH IN SOUTH ASIA. IT IS THE SE-ENTH LAR-EST COUNTRH -H AREA, THE SECOND EOST POPULOUS COUNTRH, AND THE EOST POPULOUS DEEOCRACH IN THE -ORLD. -OUNDED -H THE INDIAN OCEAN ON THE SOUTH, THE ARA-IAN SEA ON THE SOUTH-EST, AND THE -AH OF -EN-AL ON THE SOUTHEAST, IT SHARES LAND -ORDERS -ITH PA-ISTAN TO THE -EST; CHINA, NEPAL, AND -HUTAN TO THE NORTH; AND -AN-LADESH AND EHANEAR TO THE EAST. IN THE INDIAN OCEAN, INDIA IS IN THE -ICINITH OF SRI LAN-A AND THE EALDI-ES; ITS ANDAEAN AND NICO-AR ISLANDS SHARE A EARITIEE -ORDER -ITH THAILAND, EHANEAR AND INDONESIA. -OOD, NO- TURN FOR THE SECOND PART OF THE -UESTION, -OOD LUC-!"
        words = sentence.split()
        corrected_words = {}
        for word in words:
            if '-' in word:
                continue
            # Optionally, retain punctuation by stripping it out and adding it back later
            stripped_word = word.strip(".,!?;:")
            # Get the most likely correction
            correction = spell.correction(stripped_word)
            if word[-1] in ".,!?;:":
                correction += word[-1]
            word=word.upper()
            if word==correction or len(word)!=len(correction):
                continue

            corrected_words[word]=correction.upper()
           
            
        return corrected_words    

# def find_letter_differences(wrong, correct):
#     """
#     Compare the two words letter by letter and return a list of differences.
    
#     Each difference is a tuple: (position, letter_in_wrong, letter_in_correct)
#     """
#     differences = []
#     # Compare up to the length of the shorter word
#     min_length = min(len(wrong), len(correct))
#     for i in range(min_length):
#         if wrong[i] != correct[i]:
#             differences.append((i, wrong[i], correct[i]))
            
#     # If one word is longer than the other, record the extra letters as differences.
#     if len(wrong) > len(correct):
#         for i in range(min_length, len(wrong)):
#             differences.append((i, wrong[i], None))
#     elif len(correct) > len(wrong):
#         for i in range(min_length, len(correct)):
#             differences.append((i, None, correct[i]))
            
#     return differences


def spellCheckerAndUpdateAll(plaintext,
                             ciphertext,
                             cipherletterToPlaintextMapping,
                             plainletterToCiperletterMapping,
                             MappingFromCipherwordToPlainword,
                             MappingFromPlainwordToCipherword):
    """
    Updates the plaintext and all mappings using the corrections provided by the spellchecker.
    
    :param plaintext: The original plaintext string.
    :param ciphertext: The cipher text string.
    :param cipherletterToPlaintextMapping: Dictionary mapping cipher letters to plaintext letters (or lists of candidates).
    :param plainletterToCiperletterMapping: Dictionary mapping plaintext letters to cipher letters.
    :param MappingFromCipherwordToPlainword: Dictionary mapping cipher words to plain words.
    :param MappingFromPlainwordToCipherword: Dictionary mapping plain words to cipher words.
    :return: Updated versions of plaintext and all mappings.
    """
    
    # Obtain a list of words from plaintext (using your custom splitting function)
    wordList = getSplitSemiPlaintext(plaintext)
    
    # Perform spell checking to get corrections, e.g.,
    # correctedWord = {"WRNG": "WRONG", ...}
    correctedWord = spellChecker(wordList)
    
    # Print out the corrections (for debugging)
    # for wrong, correct in correctedWord.items():
    #     print(f"Incorrect: '{wrong}' -> Correct: '{correct}'")


    for wrong, correct in correctedWord.items():
        print(f"Incorrect: '{wrong}' -> Correct: '{correct}'")
        diffs = find_letter_differences(wrong, correct)
        if diffs:
            for pos, wrong_char, correct_char in diffs:
                if wrong_char is None:
                    print(f"  At position {pos}: missing letter, corrected to '{correct_char}'")
                elif correct_char is None:
                    print(f"  At position {pos}: extra letter '{wrong_char}' removed")
                else:
                    print(f"  At position {pos}: '{wrong_char}' changed to '{correct_char}'")
                # cipherletter=plainletterToCiperletterMapping[wrong_char][0]
                # cipherletterToPlaintextMapping[cipherletter][0]=correct_char
                # plainletterToCiperletterMapping[correct_char].append(cipherletter) 



        else:
            print("  No differences found.")


    
    # --- 1. Update the plaintext ---
    # Replace each wrong word with the correct one in the plaintext.
    for wrong, correct in correctedWord.items():
        # We use replace() here; if words occur multiple times this will update all.
        plaintext = plaintext.replace(wrong, correct)
    
    
    return (plaintext,
            cipherletterToPlaintextMapping,
            plainletterToCiperletterMapping,
            MappingFromCipherwordToPlainword,
            MappingFromPlainwordToCipherword)




#redefineCipherletterToPlaintextMapping("--AR--ARD -AS DES-GNED -Y ATSU-O N-S--DA -OR T-E --RST GENERAT-ON O- PO--ET -ONSTERS GA-ES RED AND GREEN, ----- -ERE LO-AL--ED OUTS-DE -APAN AS PO-E-ON RED AND -LUE. --AR--ARD -AS DES-GNED -E-ORE --AR-ANDER, T-E LATTER -E-NG A-TUALLY -ASED ON T-E -OR-ER. OR-G-NALLY -ALLED L--ARDON -N -APANESE, N-NTENDO DE--DED TO G-VE T-E VAR-OUS PO-E-ON SPE--ES  -LEVER AND DES-R-PT-VE NA-ES RELATED TO T-E-R APPEARAN-E OR -EATURES --EN TRANSLAT-NG T-E GA-E -OR -ESTERN AUD-EN-ES AS A -EANS TO -A-E T-E --ARA-TERS -ORE RELATA-LE TO A-ER--AN ---LDREN. AS A RESULT, T-EY -ERE RENA-ED --AR--ARD, A PORT-ANTEAU O- T-E -ORDS --AR-OAL OR --AR AND L--ARD",12,12,12,2)    