def anagram_difference(str1, str2)
  diff_chars = []
  diff_chars << str1.chars.difference(str2.chars)
  diff_chars << str2.chars.difference(str1.chars)
  p diff_chars.flatten
end

# p anagram_difference('', '') == 0
# p anagram_difference('a', '') == 1
# p anagram_difference('', 'a') == 1
# p anagram_difference('ab', 'a') == 1
# p anagram_difference('ab', 'ba') == 0
# p anagram_difference('ab', 'cd') == 4
p anagram_difference('aab', 'a') == 2
p anagram_difference('a', 'aab') == 2
p anagram_difference('codewars', 'hackerrank') == 10
