return {
  tag = 'sourcePlayback',
  summary = 'Set whether or not the Source loops.',
  description = 'Sets whether or not the Source loops.',
  arguments = {
    loop = {
      type = 'boolean',
      description = 'Whether or not the Source will loop.'
    }
  },
  returns = {},
  variants = {
    {
      arguments = { 'loop' },
      returns = {}
    }
  },
  notes = 'Attempting to loop a Source backed by a stream `Sound` will cause an error.'
}
