

# Models the list of characters in the chain. The characters each have
# a corresponding int value, which is the proportion of those
# characters which follow the key pattern.
class CharList

  constructor: ->
    @chars = {}

  # add a single character
  add: (char) =>
    @chars[char] ||= 0
    @chars[char] += 1

  chars:
    @chars

  # sum up all the character values
  total: =>
    (val for char,val of @chars).reduce (t, s) -> t + s

  # select a character based on a random value compared with the
  # character probability factor
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
  choice: (selection = Math.floor(Math.random() * this.total)) =>
    chars = []
    chars.push [char, sum + count] for char, count of @chars
    ((selection > position) for char, position in chars).index true


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
    console.log @key
    @addChar char for char in string
    @store[@key] || = new CharList()
    @store[@key].add(new EndWord)

  addChar: (char) =>
    #console.log char
    @store[@key] ||= new CharList
    @store[@key].add char
    #console.log @store[@key]
    @key.push(char)
    @key.shift()
    #console.log @key

# Markov chain representation using a Markov Chain implementation to
# make fantasy words from list of corpora.
class MarkovChain

  constructor: (corpora, dictionary, lookback = 2) ->
    @content = ""
    @loadCorpora corpora
    $.get dictionary, {}, (data) => @dictionary = data if dictionary
    @lookback = lookback
    @words = {}
    @chain = new Chain(@lookback)
    @makeWords()

  loadCorpora: (corpora) =>
    $.get('/language/corpus/load', {corpus: corpus}, (data) => @content += data)  for corpus in corpora

  makeWords: =>
    (english, madeUp) ->  @words[english] = madeUp for english, madeUp in [].push [word, @makeWord()] for word of @dictionary
    @words

  makeWord: =>
    word = ""
    key = []
    key.push new StartWord for i in [lookback..0]
    while true
      char = @chain[key].choice()
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
