import Vapor

final class UserController {

  // view with users
  func list(_ req: Request) throws -> Future<View> {
    return User.query(on: req).all().flatMap { users in
      let data = ["userlist": users]
      return try req.view().render("list", data)
    }
  }

  // view with users
  func show(_ req: Request) throws -> Future<View> {
    return try req.parameters.next(User.self).flatMap { user in
      return try req.view().render("show", user)
    }
  }

  // create a new user
  func create(_ req: Request) throws -> Future<Response> {
    return try req.content.decode(User.self).flatMap { user in
      return user.save(on: req).map { _ in
        return req.redirect(to: "users")
      }
    }
  }

  // update an existing user
  func update(_ req: Request) throws -> Future<Response> {
    return try req.parameters.next(User.self).flatMap { user in
      return try req.content.decode(UserForm.self).flatMap { userForm in
        user.username = userForm.username
        return user.save(on: req).map { _ in
          return req.redirect(to: "/users")
        }
      }
    }
  }

  func delete(_ req: Request) throws -> Future<Response> {
    return try req.parameters.next(User.self).flatMap { user in
      return user.delete(on: req).map { _ in
        return req.redirect(to: "/users")
      }
    }
  }
} 

// Form used to decode user for update
struct UserForm: Content {
  var username: String
}

