package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"
	"github.com/dejac17/Ecommerce-Project/routes"
	"github.com/gin-gonic/gin"
)

var ginLambda *ginadapter.GinLambda

func main() {
	// app := controllers.NewApplication(database.ProductData(database.Client, "Products"), database.UserData(database.Client, "Users"))

	router := gin.Default()

	routes.UserRoutes(router)
	// router.Use(middleware.Authentication)
	// router.GET("/addtocart", app.AddToCart())
	// router.GET("/removeitem", app.RemoveItem())
	// router.GET("/listcart", controllers.GetItemFromCart())
	// router.POST("/addaddress", controllers.AddAddress())
	// router.PUT("/edithomeaddress", controllers.EditHomeAddress())
	// router.PUT("/editworkaddress", controllers.EditWorkAddress())
	// router.GET("/deleteaddresses", controllers.DeleteAddress())
	// router.GET("/cartcheckout", app.BuyFromCart())
	// router.GET("/instantbuy", app.InstantBuy())

	ginLambda = ginadapter.New(router)
	lambda.Start(Handler)
}

func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return ginLambda.ProxyWithContext(ctx, req)
}
