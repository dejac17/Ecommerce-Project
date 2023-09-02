package routes

import (
	"github.com/dejac17/Ecommerce-Project/controllers"
	"github.com/gin-gonic/gin"
)

func UserRoutes(incomingRooutes *gin.Engine) {
	incomingRooutes.POST("/users/signup", controllers.SignUp())
	incomingRooutes.POST("/users/login", controllers.Login())
	incomingRooutes.POST("/admin/addproduct", controllers.ProductViewerAdmin())
	incomingRooutes.GET("/users/productreview", controllers.SearchProduct())
	incomingRooutes.GET("/users/search", controllers.SearchProductByQuery())
}
