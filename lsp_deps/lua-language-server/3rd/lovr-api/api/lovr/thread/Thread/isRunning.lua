return {
  summary = 'Check if the Thread is running.',
  description = 'Returns whether or not the Thread is currently running.',
  arguments = {},
  returns = {
    running = {
      type = 'boolean',
      description = 'Whether or not the Thread is running.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'running' }
    }
  },
  related = {
    'Thread:start'
  }
}
