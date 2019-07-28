# this is a test of UML

## first diagram

````plantuml
@startuml
    skinparam backgroundColor #aEEBDC
    skinparam handwritten false
    actor jeremy
    Customer -> "login()" : username & password
    "login()" -> Customer : session token
    activate "login()"
    Customer -> "placeOrder()" : session token, order info
    "placeOrder()" -> Customer : ok
    Customer -> "logout()"

    "logout()" -> Customer : ok
    deactivate "login()"
@enduml
````

## uml: state diagram

```plantuml
@startuml
scale 600 width
skinparam backgroundColor #FFEBDC
[*] -> Begin
Begin -right-> Running : Succeeded
Begin --> [*] : Aborted
state Running {
  state "The game runneth" as long1
  long1 : Until you die
  long1 --> long1 : User interaction
  long1 --> keepGoing : stillAlive
  keepGoing --> long1
  long1 --> tooBadsoSad : killed
  tooBadsoSad --> Dead : failed
}
Dead --> [*] : Aborted
@enduml
```

## describing PSPrompt in UML

````plantuml
@startuml
actor User
    User-> "PSPrompt Module()" : Install Module
    User-> "PSPrompt Module()" : Import Module


@enduml
````

