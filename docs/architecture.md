# Architectural requirements
## Architectural design strategy

## Architectural strategies

## Architectural quality requirements
- **Availability:** The system should have at least 99% uptime for the essential services (notably database access for reading and making posts).
- **Usability:** The app and web interfaces should function smoothly on most devices, dynamically resizing interface elements to fit a reasonable variety of modern screen sizes.
- **Scalability:** Backend functionality should be implemented in part through Firebase’s functions, ensuring smooth horizontal scaling. The system should be able to handle at least 30 requests per second. 
- **Performance:** Firebase queries (especially database queries) should be optimised to only return the minimum data needed to fulfil a request, to avoid wasting bandwidth and memory on loading unnecessary information. 
- **Security:** Firestore Security rules should be used to ensure that users do not have access to sensitive data, using role-based access control.

## Architectural design and pattern

## Architectural constraints

## Technology choices