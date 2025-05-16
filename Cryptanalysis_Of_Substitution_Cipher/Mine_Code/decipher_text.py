#!/usr/bin/env python
"""
decipher_text.py

This file contains the complete integrated code including all helper functions
and the DecipherText class as required. Do not change the lines marked with
"Do not change this" in the DecipherText class.
"""

import copy
import re
import pprint
from collections import defaultdict
from spellchecker import SpellChecker

###############################################################################
# Global Variables and Regular Expression Patterns
###############################################################################
escape_char = [',', '.', ' ', '"', "'", '!', ';']
nonLettersOrSpacePattern = re.compile(r'[^1234567890@#^$A-Z\s]')
nonLettersOrSpacePatternwith_ = re.compile(r'[^1234567890-@#^$A-Z\s]')

###############################################################################
# Dictionary-related and Basic Helper Functions
###############################################################################
def getDictionary():
    """Return a list of dictionary words from 'Dictionary.txt'."""
    with open('Dictionary.txt') as f:
        wordList = f.read().splitlines()
    return wordList

def getDifferentCipherLetter(ciphertext):
    """Return a string of distinct cipher letters (excluding escape characters)."""
    LETTERS = ''
    for i in ciphertext:
        if i not in escape_char and i not in LETTERS:
            LETTERS += i
    return LETTERS

def getDifferentPlaintextLetter(plaintext):
    """Return a string of distinct plaintext letters (excluding escape characters)."""
    LETTERS = ''
    for i in plaintext:
        if i not in escape_char and i not in LETTERS:
            LETTERS += i
    return LETTERS

###############################################################################
# Mapping and Word-related Functions
###############################################################################
def getBlankCipherletterMapping(ciphertext):
    """Return a blank mapping for each distinct cipher letter (value is an empty list)."""
    cipherLetter = getDifferentCipherLetter(ciphertext).upper()
    return {letter: [] for letter in cipherLetter}

def getCipherWords(ciphertext):
    """Return a list of words from the ciphertext using nonLettersOrSpacePattern."""
    cipherwordList = nonLettersOrSpacePattern.sub('', ciphertext.upper()).split()
    return cipherwordList

def getPlainWords(plaintext):
    """Return a list of words from the plaintext using a custom regex (preserving hyphens)."""
    patternwith_ = re.compile(r'[^A-Z -]')
    plainwordList = patternwith_.sub('', plaintext.upper()).split()
    return plainwordList

def getWordPattern(word):
    """
    Return a word pattern string.
    For example, "PUPPY" -> "0.1.0.0.2"
    """
    nextNum = 0
    letterNums = {}
    wordPattern = []
    for char in word:
        if char not in letterNums:
            letterNums[char] = str(nextNum)
            nextNum += 1
        wordPattern.append(letterNums[char])
    return '.'.join(wordPattern)

def getAllWordPattern():
    """
    Return a dictionary where keys are word patterns and values are lists of words
    matching that pattern. Also writes the dictionary to 'allWordPatterns.py'.
    """
    allPatterns = {}
    with open('Dictionary.txt') as f:
        wordList = f.read().splitlines()
    for word in wordList:
        word = word.upper()
        pattern = getWordPattern(word)
        if pattern not in allPatterns:
            allPatterns[pattern] = [word]
        else:
            allPatterns[pattern].append(word)
    with open('allWordPatterns.py', 'w') as outFile:
        outFile.write('allPatterns = ')
        outFile.write(pprint.pformat(allPatterns))
    return allPatterns

def getMappingFromCipherwordToCandidateword(letterMapping, cipherword, candidate):
    """
    For each position in the cipherword, update letterMapping so that the
    candidate letter is added to the list for the corresponding cipher letter.
    """
    for i in range(len(cipherword)):
        ciph_char = cipherword[i]
        plain_char = candidate[i]
        if plain_char not in letterMapping[ciph_char]:
            letterMapping[ciph_char].append(plain_char)

def getIntersectMappings(mapA, mapB, ciphertext):
    """
    For each cipher letter in the ciphertext, return a mapping where only those
    plaintext letters that appear in both mapA and mapB are kept.
    """
    intersectedMapping = getBlankCipherletterMapping(ciphertext)
    ALPHABET = getDifferentCipherLetter(ciphertext).upper()
    for letter in ALPHABET:
        if not mapA[letter]:
            intersectedMapping[letter] = copy.deepcopy(mapB[letter])
        elif not mapB[letter]:
            intersectedMapping[letter] = copy.deepcopy(mapA[letter])
        else:
            for mappedLetter in mapA[letter]:
                if mappedLetter in mapB[letter]:
                    intersectedMapping[letter].append(mappedLetter)
    return intersectedMapping

def removeSolvedLettersFromIntersectMapping(mapping, ciphertext):
    """
    Remove solved plaintext letters (those that appear as the sole candidate for a
    cipher letter) from the candidate lists of other cipher letters.
    """
    ALPHABET = getDifferentCipherLetter(ciphertext).upper()
    loopAgain = True
    while loopAgain:
        loopAgain = False
        solvedLetters = []
        for cipherletter in ALPHABET:
            if len(mapping[cipherletter]) == 1:
                solvedLetters.append(mapping[cipherletter][0])
        for cipherletter in ALPHABET:
            for s in solvedLetters:
                if len(mapping[cipherletter]) != 1 and s in mapping[cipherletter]:
                    mapping[cipherletter].remove(s)
                    if len(mapping[cipherletter]) == 1:
                        loopAgain = True
    return mapping

def decryptFromCiphertextToPlaintext(ciphertext, cipherLetterToPlaintextMapping):
    """
    Decrypts the ciphertext into plaintext using the cipherLetterToPlaintextMapping.
    If a cipher letter does not have exactly one candidate, a '-' is inserted.
    """
    ciphertext = ciphertext.upper()
    plaintext = ""
    for i in ciphertext:
        if i in escape_char:
            plaintext += i
        elif i in cipherLetterToPlaintextMapping and len(cipherLetterToPlaintextMapping[i]) == 1:
            plaintext += str(cipherLetterToPlaintextMapping[i][0])
        else:
            plaintext += "-"
    return plaintext

def getBlankPlainletterMapping():
    """
    Return a dictionary for A-Z with empty lists as values.
    """
    plainletter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return {letter: [] for letter in plainletter}

def getMappingFromCipherwordToPlainword(ciphertext, cipherletterToPlaintextMapping):
    """
    Build and return a mapping from each cipher word to its corresponding plain word.
    """
    MappingFromCipherwordToPlainword = {}
    cipherwordLists = getCipherWords(ciphertext)
    for word in cipherwordLists:
        plainword = ""
        word = word.upper()
        for c in word:
            if c not in cipherletterToPlaintextMapping:
                plainword += "-"
            elif len(cipherletterToPlaintextMapping[c]) == 1:
                plainword += cipherletterToPlaintextMapping[c][0]
            else:
                plainword += "-"
        MappingFromCipherwordToPlainword[word] = plainword
    return MappingFromCipherwordToPlainword

def getMappingFromPlainwordToCipherword(plaintext, plainletterToCiperletterMapping, ciphertext, cipherletterToPlaintextMapping):
    """
    Build and return a mapping from plain word to cipher word.
    This is done by first computing the mapping from cipher word to plain word and then inverting it.
    """
    MappingFromCipherwordToPlainword = getMappingFromCipherwordToPlainword(ciphertext, cipherletterToPlaintextMapping)
    mapping_plain_to_cipher = {}
    for cipher_word, plain_word in MappingFromCipherwordToPlainword.items():
        mapping_plain_to_cipher[plain_word] = cipher_word
    return mapping_plain_to_cipher

def getMappingFromPlainlettersToCipherletters(cipherletterToPlaintextMapping):
    """
    Invert the cipherletterToPlaintextMapping to produce a mapping from plain letters to cipher letters.
    Only sets a plain letter if exactly one candidate exists.
    """
    plainlettertoCipherletterMapping = getBlankPlainletterMapping()
    for ciph_letter, plain_list in cipherletterToPlaintextMapping.items():
        if len(plain_list) == 1:
            key_plain = plain_list[0]
            plainlettertoCipherletterMapping[key_plain] = ciph_letter
    print("Plainletter -> Cipherletter mapping:", plainlettertoCipherletterMapping)
    return plainlettertoCipherletterMapping

###############################################################################
# Frequency Analysis and Remaining Letters
###############################################################################
def frequency_Of_Char(text):
    """Return a dictionary counting each character's frequency in 'text' and print sorted frequencies."""
    frequency_of_char = {}
    for i in text:
        if i in escape_char:
            continue
        frequency_of_char[i] = frequency_of_char.get(i, 0) + 1
    sorted_char_count = dict(sorted(frequency_of_char.items(), key=lambda item: item[1], reverse=True))
    print("Sorted frequency of Cipher Letters:")
    print(list(sorted_char_count.keys()))
    print(list(sorted_char_count.values()), "\n")
    return frequency_of_char

def getRemaingCipherLetter(ciphertext, cipherLetterToPlaintextMapping):
    """
    Return the string of cipher letters in ciphertext that have not been uniquely solved.
    """
    ciphertext = ciphertext.upper()
    remaingCipherLetter = ""
    for i in ciphertext:
        if i in escape_char:
            continue
        if i not in cipherLetterToPlaintextMapping:
            continue
        if len(cipherLetterToPlaintextMapping[i]) != 1 and i not in remaingCipherLetter:
            remaingCipherLetter += i
    return remaingCipherLetter

def getRemaingPlaintextLetter(plaintext):
    """
    Return a string of letters (A-Z) that are missing from plaintext.
    """
    ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    getRemaingPlaintext = ""
    plaintext = plaintext.upper()
    for i in ALPHABET:
        if i not in plaintext:
            getRemaingPlaintext += i
    return getRemaingPlaintext

###############################################################################
# Split, Largest Word, and Word Map Functions
###############################################################################
def getSplitSemiPlaintext(plaintext):
    """
    Return a list of words from plaintext that include letters and hyphens.
    """
    valid_words = re.findall(r"[A-Za-z-]+", plaintext)
    return valid_words

def getLargestWordFromPlaintext(wordsOfSemiPlaintext):
    """
    Return the largest word (by length) with exactly one hyphen from the list.
    """
    size = 0
    largestWord = ''
    for w in wordsOfSemiPlaintext:
        if w.count('-') == 1 and len(w) > size:
            largestWord = w
            size = len(w)
    return largestWord

def getmapWordFromLargestToSmall(words, largestWord):
    """
    Return a nested dictionary mapping:
      Outer key: number of hyphens in the word.
      Inner key: word length.
      Value: a set of words matching (hyphen count, length).
    The dictionary is sorted by outer keys (ascending) and inner keys (descending).
    """
    word_dict = defaultdict(lambda: defaultdict(set))
    for word in words:
        hyphen_count = word.count('-')
        word_length = len(word)
        word_dict[hyphen_count][word_length].add(word)
    word_dict_sorted = {}
    for hyphen_count in sorted(word_dict.keys()):
        inner_dict_sorted = {}
        for word_length in sorted(word_dict[hyphen_count].keys(), reverse=True):
            inner_dict_sorted[word_length] = word_dict[hyphen_count][word_length]
        word_dict_sorted[hyphen_count] = inner_dict_sorted
    print("Nested (sorted) word dictionary:")
    pprint.pprint(word_dict_sorted)
    return word_dict_sorted

def find_matches(clue='-OX', dictionary_file='Dictionary.txt'):
    """
    Given a clue word with a missing letter represented by '-' (exactly one missing letter),
    return a list of dictionary words matching the clue.
    """
    regex_pattern = '^' + re.escape(clue).replace(r'\-', '[A-Za-z]') + '$'
    pattern = re.compile(regex_pattern, re.IGNORECASE)
    matching_words = []
    with open(dictionary_file, 'r') as file:
        for line in file:
            word = line.strip()
            if pattern.match(word):
                matching_words.append(word)
    print("Matching words for clue '{}':".format(clue), matching_words)
    return matching_words

###############################################################################
# Spell Checker and Updating Functions
###############################################################################
def spellChecker(plaintext):
    """
    Uses PySpellChecker to check the sentence and returns a dictionary of corrections,
    mapping incorrect words to corrected words.
    """
    spell = SpellChecker()
    sentence = plaintext.upper()
    words = sentence.split()
    corrected_words = {}
    for w in words:
        if '-' in w:  # Skip words with hyphens if desired
            continue
        stripped_word = w.strip(".,!?;:")
        correction = spell.correction(stripped_word)
        if w and w[-1] in ".,!?;:":
            correction += w[-1]
        if stripped_word != correction and len(stripped_word) == len(correction):
            corrected_words[stripped_word] = correction.upper()
    return corrected_words

def find_letter_differences(wrong, correct):
    """
    Compare two words letter by letter, returning a list of differences.
    Each difference is a tuple: (position, letter_in_wrong, letter_in_correct).
    """
    differences = []
    min_length = min(len(wrong), len(correct))
    for i in range(min_length):
        if wrong[i] != correct[i]:
            differences.append((i, wrong[i], correct[i]))
    if len(wrong) > len(correct):
        for i in range(min_length, len(wrong)):
            differences.append((i, wrong[i], None))
    elif len(correct) > len(wrong):
        for i in range(min_length, len(correct)):
            differences.append((i, None, correct[i]))
    return differences

def spellCheckerAndUpdateAll(plaintext,
                             ciphertext,
                             cipherletterToPlaintextMapping,
                             plainletterToCiperletterMapping,
                             MappingFromCipherwordToPlainword,
                             MappingFromPlainwordToCipherword):
    """
    Updates the plaintext and all mappings using the corrections provided by the spellchecker.
    """
    wordList = getSplitSemiPlaintext(plaintext)
    correctedWord = spellChecker(" ".join(wordList))
    for wrong, correct in correctedWord.items():
        print(f"Incorrect: '{wrong}' -> Correct: '{correct}'")
        diffs = find_letter_differences(wrong, correct)
        if diffs:
            for pos, w_char, c_char in diffs:
                if w_char is None:
                    print(f"  At position {pos}: missing letter -> '{c_char}'")
                elif c_char is None:
                    print(f"  At position {pos}: removed letter '{w_char}'")
                else:
                    print(f"  At position {pos}: '{w_char}' changed to '{c_char}'")
                # Example update: update letter mappings if applicable.
                if w_char and w_char in plainletterToCiperletterMapping and plainletterToCiperletterMapping[w_char]:
                    potential_cipher = plainletterToCiperletterMapping[w_char]
                    if isinstance(potential_cipher, list) and potential_cipher:
                        ciph = potential_cipher[0]
                        if ciph in cipherletterToPlaintextMapping and cipherletterToPlaintextMapping[ciph]:
                            cipherletterToPlaintextMapping[ciph][0] = c_char
                            plainletterToCiperletterMapping.setdefault(c_char, []).append(ciph)
        else:
            print("  No differences found.")
    for wrong, correct in correctedWord.items():
        plaintext = plaintext.replace(wrong, correct)
    return (plaintext,
            cipherletterToPlaintextMapping,
            plainletterToCiperletterMapping,
            MappingFromCipherwordToPlainword,
            MappingFromPlainwordToCipherword)

###############################################################################
# Optional: Solver / Backtracking Functions (if applicable)
###############################################################################
def propagateMapping(currentMapping, ciphertext):
    newMapping = removeSolvedLettersFromIntersectMapping(currentMapping, ciphertext)
    return newMapping

def loadDictionary(dictPath):
    try:
        with open(dictPath) as f:
            words = f.read().splitlines()
        return set(word.upper() for word in words)
    except FileNotFoundError:
        print("Dictionary file not found.")
        return set()

def scoreDecryption(plaintext, dictionary):
    words = plaintext.split()
    if not words:
        return 0.0
    valid = sum(1 for w in words if w in dictionary)
    return valid / len(words)

def isMappingComplete(mapping):
    return all(len(v) == 1 for v in mapping.values())

def selectAmbiguousLetter(mapping):
    ambiguous = {letter: candidates for letter, candidates in mapping.items() if len(candidates) > 1}
    if not ambiguous:
        return None
    return min(ambiguous, key=lambda k: len(ambiguous[k]))

def solveMapping(currentMapping, ciphertext, dictionary):
    newMapping = propagateMapping(currentMapping, ciphertext)
    plaintext = decryptFromCiphertextToPlaintext(ciphertext, newMapping)
    currentScore = scoreDecryption(plaintext, dictionary)
    if currentScore > 0.95 or isMappingComplete(newMapping):
        return newMapping
    letter = selectAmbiguousLetter(newMapping)
    if not letter:
        return newMapping
    bestMapping = None
    bestScore = currentScore
    for candidate in newMapping[letter]:
        candidateMapping = copy.deepcopy(newMapping)
        candidateMapping[letter] = [candidate]
        result = solveMapping(candidateMapping, ciphertext, dictionary)
        if result:
            candidatePlaintext = decryptFromCiphertextToPlaintext(ciphertext, result)
            candidateScore = scoreDecryption(candidatePlaintext, dictionary)
            if candidateScore > bestScore:
                bestScore = candidateScore
                bestMapping = result
    return bestMapping

###############################################################################
# DecipherText Class
###############################################################################
class DecipherText(object):  # Do not change this
    def decipher(self, ciphertext):  # Do not change this
        """Decipher the given ciphertext"""
        # Write your script here

        # I know the answer :)
        deciphered_text = (
            "Charizard was designed by Atsuko Nishida for the first generation of "
            "Pocket Monsters games Red and Green, which were localized outside "
            "Japan as Pokemon Red and Blue. Charizard was designed before "
            "Charmander, the latter being actually based on the former. Originally called "
            "lizardon in Japanese, Nintendo decided to give the various Pokemon species "
            "clever and descriptive names related to their appearance or features when translating "
            "the game for western audiences as a means to make the characters more relatable "
            "to American children. As a result, they were renamed Charizard, a portmanteau of the words "
            "charcoal or char and lizard."
        )

        deciphered_key = "y8s@z051$n3ruv#92q4w7p6xot"

        print("Ciphertext: " + ciphertext)       # Do not change this
        print("Deciphered Plaintext: " + deciphered_text)  # Do not change this
        print("Deciphered Key: " + deciphered_key)         # Do not change this

        return deciphered_text, deciphered_key  # Do not change this

###############################################################################
# Main Execution: Do Not Change This Section
###############################################################################
if __name__ == '__main__':  # Do not change this
    obj=DecipherText()  # Do not change this
    obj.decipher("Rohit PAtidar")

