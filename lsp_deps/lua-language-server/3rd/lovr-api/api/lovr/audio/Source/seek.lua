return {
  tag = 'sourcePlayback',
  summary = 'Set the playback position of the Source.',
  description = 'Seeks the Source to the specified position.',
  arguments = {
    position = {
      type = 'number',
      description = 'The position to seek to.'
    },
    unit = {
      type = 'TimeUnit',
      default = [['seconds']],
      description = 'The units for the seek position.'
    }
  },
  returns = {},
  variants = {
    {
      arguments = { 'position', 'unit' },
      returns = {}
    }
  },
  notes = 'Seeking a Source backed by a stream `Sound` has no meaningful effect.'
}
