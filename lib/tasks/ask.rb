module Ask
  def ask(question, opts={})
    default  = opts.delete(:default)
    choices = opts.delete(:choices)
    begin
      STDOUT.flush
      puts question
      answer = STDIN.gets.chomp!
    end
  end
end