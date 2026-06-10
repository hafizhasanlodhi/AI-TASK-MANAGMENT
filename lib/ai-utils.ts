export async function withRetry<T>(fn: () => Promise<T>, retries = 5, delay = 3000): Promise<T> {
  try {
    return await fn();
  } catch (error: any) {
    // Retry on 503 (Service Unavailable), 504 (Gateway Timeout), or 429 (Too Many Requests)
    if (retries > 0 && (error.status === 503 || error.status === 504 || error.status === 429)) {
      console.warn(`Gemini API busy (status ${error.status}), retrying in ${delay}ms... (${retries} attempts left)`);
      await new Promise((resolve) => setTimeout(resolve, delay));
      return withRetry(fn, retries - 1, delay * 2); // Double the delay each time
    }
    throw error;
  }
}
