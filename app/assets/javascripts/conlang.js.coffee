

# Models the list of characters in the chain. The characters each have
# a corresponding int value, which is the proportion of those
# characters which follow the key pattern.
class CharList

  constructor: ->
    @chars = {}
    @total = 0

  # add a single character
  add: (char) =>
    @chars[char] ||= 0
    @chars[char] += 1
    @total += 1

  chars:
    @chars

  # sum up all the character values
  total: =>
    @total

  # select a character based on a random value compared with the
  # character probability factorposition
  #
  # for example, assuming a structure of
  # a: 22
  # d: 5
  # e: 45
  # ..etc
  #
  # c = new Charlist
  # ... create structure as above ...
  # c.choice(25)
  # > 'd'
  #
  choice: (selection) =>
    selection = Math.ceil(Math.random() * @total) unless selection
    chars = {}
    sum = 0
    chars[char] = sum += count for char, count of @chars
    console.log (((position >= selection) ? char : false) for char, position of chars)


# The histogram of letter probabilities. It is keyed by tuples, the
# length of which is defined by the lookback parameter.
class Chain

  constructor: (lookback = 2) ->
    @lookback = lookback
    @store = {}
    @key = []

  add: (string) =>
    @key = []
    @key.push new StartWord() for i in [@lookback..0]
    @addChar char for char in string.replace(/[0-9\.,-\/#!$%\^&\*;:{}=\-_~()]/g,"").toLowerCase()

  addChar: (char) =>
    @store[@key] ||= new CharList()
    @store[@key].add char
    @key.push(char)
    @key.shift()

# Markov chain representation using a Markov Chain implementation to
# make fantasy words from list of corpora.
class MarkovChain

  constructor: (corpora, dictionary, lookback = 2) ->
    @content = ""
    @lookback = lookback
    @chain = new Chain(@lookback)
    @loadCorpora corpora
    #$.get dictionary, {}, (data) => @dictionary = data if dictionary
    @dictionary = ['alpha', 'bravo', 'charlie', 'delta']
    @words = {}
    @makeWords()

  loadCorpora: (corpora) =>
    $.get('/language/corpus/load', {corpus: corpus}, (data) => @chain.add data)  for corpus in corpora

  makeWords: =>
    (english, madeUp) =>  @words[english] = madeUp for english, madeUp in ([].push [word, @makeWord()] for word of @dictionary)
    @words

  makeWord: =>
    word = ""
    key = []
    key.push new StartWord for i in [@lookback..0]
    while @chain.store[key]
      char = @chain.store[key].choice()
      if typeof char == 'EndWord'
        break
      word += char
      key.push char
      key.shift()
    return word


# Stub class to provide a start of word marker
class StartWord
# nop

# Stub class to provide an end of word marker
class EndWord
#nop


$ ->
  window.CharList = CharList
  window.Chain = Chain
  window.MarkovChain = MarkovChain

  $('#language-lookback').change (e) ->
    val = $(this).val()
    val = if isNaN(parseInt(val)) then 2 else parseInt(val)
    val = 3 if val > 3
    val = 1 if val < 1
    $(this).val(val)

  $('#language-process').click (e) ->
    markovChain = new MarkovChain $('#language-corpus').val(), $('#language-lookback').val()
