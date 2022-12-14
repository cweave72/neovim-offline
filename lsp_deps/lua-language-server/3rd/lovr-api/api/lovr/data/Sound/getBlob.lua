return {
  summary = 'Get the bytes backing this Sound as a Blob.',
  description = 'Returns a Blob containing the raw bytes of the Sound.',
  arguments = {},
  returns = {
    blob = {
      type = 'Blob',
      description = 'The Blob instance containing the bytes for the `Sound`.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'blob' }
    }
  },
  notes = [[
    Samples for each channel are stored interleaved.  The data type of each sample is given by
    `Sound:getFormat`.
  ]],
  related = {
    'Blob:getPointer',
    'Image:getBlob'
  }
}
