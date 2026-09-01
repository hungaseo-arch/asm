import { toast } from 'vue-sonner'
function isRecord(value) {
  return Boolean(value && typeof value === 'object')
}
export function normalizeApiError(value) {
  if (value instanceof Error) {
    return { code: 'REQUEST_ERROR', message: value.message }
  }
  if (typeof value === 'string') {
    return { code: 'REQUEST_ERROR', message: value }
  }
  if (isRecord(value)) {
    const nestedError = value.error
    if (isRecord(nestedError)) {
      return {
        code: typeof nestedError.code === 'string' ? nestedError.code : 'REQUEST_ERROR',
        message: typeof nestedError.message === 'string' ? nestedError.message : 'Request failed',
      }
    }
    return {
      code: typeof value.code === 'string' ? value.code : 'REQUEST_ERROR',
      message: typeof value.message === 'string' ? value.message : 'Request failed',
    }
  }
  return { code: 'REQUEST_ERROR', message: 'Request failed' }
}
export async function readResponseBody(response) {
  const text = await response.text()
  if (!text) return null
  try {
    return JSON.parse(text)
  } catch {
    return text
  }
}
export async function notifyApiError(response, fallbackMessage = 'Request failed') {
  const body = await response.clone().text()
  const parsedBody = body
    ? (() => {
        try {
          return JSON.parse(body)
        } catch {
          return body
        }
      })()
    : { message: fallbackMessage }
  const error = normalizeApiError(parsedBody)
  toast.error(error.message, { description: error.code })
}
