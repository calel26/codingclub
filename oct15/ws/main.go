package main

import (
	"fmt"
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type Client struct {
	conn *websocket.Conn
	name string
}

var clients = make(map[*Client]bool)
var mu sync.Mutex

func broadcast(message map[string]string) {
	mu.Lock()
	defer mu.Unlock()
	for client := range clients {
		err := client.conn.WriteJSON(message)
		if err != nil {
			fmt.Printf("Error sending message: %v\n", err)
			client.conn.Close()
			delete(clients, client)
		}
	}
	log.Printf("%s: %s", message["name"], message["message"])
}

func handleClient(conn *websocket.Conn) {
	defer conn.Close()

	client := &Client{conn: conn}
	defer func() {
		mu.Lock()
		log.Printf("%s left", client.name)
		delete(clients, client)
		mu.Unlock()
	}()

	// Handle name registration
	var namePacket struct {
		Name string `json:"name"`
	}
	if err := conn.ReadJSON(&namePacket); err != nil {
		fmt.Println("Error reading name:", err)
		return
	}

	if namePacket.Name == "" {
		conn.WriteJSON(map[string]string{
			"error": "please supply a name!",
		})
		return
	}

	client.name = namePacket.Name
	log.Printf("%s joined", client.name)

	mu.Lock()
	clients[client] = true
	mu.Unlock()

	conn.WriteJSON(map[string]string{
		"welcome": "you can start sending messages now",
	})

	// Start listening for messages
	for {
		var messagePacket struct {
			Message string `json:"message"`
		}
		if err := conn.ReadJSON(&messagePacket); err != nil {
			fmt.Println("couldn't read message :(", err)
			break
		}

		message := map[string]string{
			"name":    client.name,
			"message": messagePacket.Message,
		}
		broadcast(message)
	}
}

func main() {
	http.HandleFunc("/chat", func(w http.ResponseWriter, r *http.Request) {
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			fmt.Println("couldn't upgrade channel", err)
			return
		}
		handleClient(conn)
	})

	fmt.Println("Chat server started on :5728")
	if err := http.ListenAndServe(":5728", nil); err != nil {
		fmt.Println("Error starting server:", err)
	}
}
