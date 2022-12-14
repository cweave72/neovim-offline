return {
  summary = 'Get the Shape\'s user data.',
  description = 'Returns the user data associated with the Shape.',
  arguments = {},
  returns = {
    data = {
      type = '*',
      description = 'The custom value associated with the Shape.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'data' }
    }
  },
  notes = 'User data can be useful to identify the Shape in callbacks.'
}
