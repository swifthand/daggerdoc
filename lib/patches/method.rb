class Method
  def with(*args, &block)
    ->(*rest) { self.receiver.send(self.original_name, *rest, *args, &block) }
  end
end
