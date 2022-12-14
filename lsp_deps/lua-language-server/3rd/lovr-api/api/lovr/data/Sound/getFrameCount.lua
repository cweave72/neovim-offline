return {
  summary = 'Get the number of frames in the Sound.',
  description = [[
    Returns the number of frames in the Sound.  A frame stores one sample for each channel.
  ]],
  arguments = {},
  returns = {
    frames = {
      type = 'number',
      description = 'The number of frames in the Sound.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'frames' }
    }
  },
  notes = 'For streams, this returns the number of frames in the stream\'s buffer.',
  related = {
    'Sound:getDuration',
    'Sound:getSampleCount',
    'Sound:getChannelCount'
  }
}
