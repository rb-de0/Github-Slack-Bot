import Kitura
import KituraNet

let router = Router()

router.post("/hook") { request, response, next in
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()
