# Requests Feature

Sprint C5 provides read-only empty, pending, in-progress, completed, and
cancelled display states using isolated local mock fixtures. No request state
machine, mutation, repository, or backend integration exists.

Sprint C6 adds a request-scoped Riverpod flow for service confirmation,
optional description, mock address selection, review, local mock submission,
and success. The flow reuses the Services mock catalog and remains separate
from production DTOs, repositories, use cases, persistence, and networking.

Sprint C7 extends the centralized history fixtures with read-only description
and location summaries, presentation-only status filters, and request detail
lookup by mock request ID. No lifecycle transition or mutation is implemented.
