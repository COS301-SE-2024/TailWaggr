# Architectural requirements
## Architectural design strategy
We have opted to design based on our quality requirements. This strategy will ensure that the project upholds our quality requirements throughout its development and, by extent, always meets the needs of the client, naturally leading to their satisfaction. This also ensures that the client’s needs are always prioritised, rather than developing according to what’s easiest for the system or the like

## Architectural strategies
## Asynchronous Messaging
### Usage
- **Notifications (get/send):** Asynchronous messaging is perfect for handling notifications. When a user performs an action that triggers a notification (e.g., a new message, a like on a post, etc.), an event can be placed on a message queue. This allows the main application to continue processing other requests without waiting for the notification to be sent.
- **Post Uploads:** When users upload posts, they can be processed asynchronously. The upload request can be placed in a queue, and a background worker can handle the actual upload, processing, and validation, improving the responsiveness of the application.

### Benefits
- Improves system responsiveness and user experience.
- Decouples components, making the system more scalable and maintainable.
- Handles high loads effectively.

## Client-Server
### Usage
- **Viewing Posts:** The client-server model is fundamental for retrieving and displaying posts. The client (web browser or mobile app) makes requests to the server, which processes the request, fetches data from the database, and sends the posts back to the client.
- **Locating Vets and Pet Sitters:** The client sends a request with location data to the server, which then queries a database or an external API to retrieve the relevant information and sends it back to the client.

### Benefits
- Separates concerns between the client (presentation layer) and the server (business logic and data access layer).
- Facilitates easier updates and maintenance, as changes to the server or client can be made independently.
- Enhances security by centralizing sensitive operations on the server.

## Component-Based
### Usage
- **Forums Page:** Implementing the forums page using a component-based architecture can modularize different functionalities (e.g., message boards, individual posts, message sending/receiving). Each component can be independently developed, tested, and maintained.
- **User Profiles:** User profiles can be divided into components such as profile picture, bio, posts, and settings. This makes the user interface more manageable and reusable.

### Benefits
- Encourages reusability of components, reducing redundancy and development time.
- Simplifies testing and debugging by isolating components.
- Enhances scalability, as individual components can be updated or replaced without affecting the entire system.


## Architectural quality requirements
- **Availability:** The system should have at least 99% uptime for the essential services (notably database access for reading and making posts).
- **Usability:** The app and web interfaces should function smoothly on most devices, dynamically resizing interface elements to fit a reasonable variety of modern screen sizes.
- **Scalability:** Backend functionality should be implemented in part through Firebase’s functions, ensuring smooth horizontal scaling. The system should be able to handle at least 30 requests per second. 
- **Performance:** Firebase queries (especially database queries) should be optimised to only return the minimum data needed to fulfil a request, to avoid wasting bandwidth and memory on loading unnecessary information. 
- **Security:** Firestore Security rules should be used to ensure that users do not have access to sensitive data, using role-based access control.

## Architectural design and pattern

## Architectural constraints

## Technology choices
