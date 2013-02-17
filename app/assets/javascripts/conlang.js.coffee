
startWord = '^'
endWord = '$'

##
# Models the list of characters in the chain. The characters each have
# a corresponding int value, which is the proportion of those
# characters which follow the key pattern.
#
class CharList

  constructor: ->
    @chars = {}
    @total = 0

  ##
  # add a single character
  #
  add: (char) =>
    @chars[char] ||= 0
    @chars[char] += 1
    @total += 1

  chars:
    @chars

  ##
  # sum of all the character values
  #
  total: =>
    @total

  ##
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
    selection = Math.floor(Math.random() * @total) unless selection
    chars = {}
    sum = 0
    chars[char] = sum += count for char, count of @chars
    for char, position of chars
      return char if position >= selection
    return false
##
# The histogram of letter probabilities. It is keyed by tuples, the
# length of which is defined by the lookback parameter.
#
class Chain

  constructor: (lookback = 2) ->
    @lookback = lookback
    @store = {}
    @key = []

  ##
  # Add a string to the store
  #
  add: (string) =>
    @key = []
    string = string + endWord
    @key.push startWord for i in [@lookback..1]
    @addChar char for char in string


  ##
  # Add a char to the store- if the char is a space, mark the
  # beginning and end of a word.
  #
  addChar: (char) =>
    @store[@key] ||= new CharList()
    @store[@key].add char
    @key.push(char)
    @key.shift()

##
# Markov chain representation using a Markov Chain implementation to
# make fantasy words from list of corpora.
#
class MarkovChain

  constructor: (corpora, callback, dictionary = '/dict.txt', lookback = 2) ->
    @callback = callback
    @progressbar = $('#progressbar')
    @steps = Math.ceil(100 / (corpora.length + 2))
    @output = $('#output')
    @words = {}
    @lookback = lookback
    @name = $('#corpora-name')
    @chain = new Chain(@lookback)
    $.get dictionary, {}, (data) =>
      @dictionary = data.split('\n') if dictionary
      this.progress()
      @loadCorpora corpora

  ##
  # Update the progress bar
  #
  progress: =>
    @progressbar.progressbar("value",  @progressbar.progressbar("value") + @steps)

  ##
  # Load the corpora set.
  #
  loadCorpora: (corpora) =>
    $.get '/language/corpus/load',
      {corpus: corpora[0]},
      (data) =>
        @progress()
        console.log corpora[0]
        @chain.add word for word in data.toLowerCase().replace(/[0-9\.,-\/#!$%\^&\*;:{}=\-_~()\[\]»«"?\n\t„]/g," ").replace(/[0-9]/g,' ').split(' ')
        if corpora.length > 1
          @loadCorpora(corpora[1..])
        else
          @saveCorpora

  ##
  # Sends the corpora set to the back end
  #
  saveCorpora: () =>
    $.post '/histogram/create',
      chain: @chain
      name: @name.value

  ##
  # Make the words out of the digested corpora.
  #
  makeWords: =>
    @words =  (@makeWord(word) for word in @dictionary)
    this.progress()
    @callback(this)
    @words

  ##
  # Make a single word.
  #
  makeWord: (original) =>
    word = ""
    char = startWord
    key = []
    key.push startWord for i in [@lookback..1]
    while not char and char is not ' '
      char = @chain.store[key].choice()
    while typeof char is not 'undefined'
      break if char is endWord
      word += char unless char is startWord
      key.push char
      key.shift()
      char = if @chain.store[key] then @chain.store[key].choice() else undefined
    [original, word]

$ ->
  window.CharList = CharList
  window.Chain = Chain
  window.MarkovChain = MarkovChain

  $('#progressbar').progressbar()

  $('#language-lookback').change (e) ->
    val = $(this).val()
    val = if isNaN(parseInt(val)) then 2 else parseInt(val)
    val = 3 if val > 3
    val = 1 if val < 1
    $(this).val(val)


  $('#language-process').click (e) ->
    $output = $('#language-output')
    $name = $('#language-name')
    $output.prepend('<h4>' + $name.val() + '</h4>')
    callback = (markovchain) ->
      $output.find('tbody').append("<tr><td>#{newword[0]}</td><td>#{newword[1]}</td></tr>") for newword in markovchain.words
      markovchain.progress()
      $.post '/language/create'
        name: $name.val()
        glossary: markovchain.words.to_json
        description: $('#language-description').val()
        (event) =>
          # nop
    try
      markovChain = new MarkovChain(
        $(corpus).val() for corpus in $('.language-corpus') when $(corpus).val() != '',
        callback,
        '/dict.txt',
        $('#language-lookback').val()
      )
    catch e
      console.log e
    finally
      false
    false
