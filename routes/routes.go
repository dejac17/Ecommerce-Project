package routes

import (
	"github.com/gin-gonic/gin"
)

func UserRoutes(incomingRooutes *gin.Engine) {
	incomingRooutes.POST("/users/signup")
	incomingRooutes.POST("/users/login")
	incomingRooutes.POST("/admin/addproduct")
	incomingRooutes.GET("/users/productreview")
	incomingRooutes.GET("/users/search")
}
