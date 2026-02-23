# SetCoach Unit Tests

To run these tests, add a **Unit Test** target in Xcode:

1. File → New → Target → Unit Testing Bundle.
2. Name it `SetCoachTests`, add to the SetCoach project.
3. Add this `SetCoachTests` folder to the new target’s **Compile Sources**.
4. In the test target’s **Build Phases**, link the **SetCoach** app target so tests can `@testable import SetCoach`.
