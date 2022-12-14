return {
  summary = 'Transpose the matrix.',
  description = 'Transposes the matrix, mirroring its values along the diagonal.',
  arguments = {},
  returns = {
    m = {
      type = 'Mat4',
      description = 'The original matrix.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'm' }
    }
  }
}
