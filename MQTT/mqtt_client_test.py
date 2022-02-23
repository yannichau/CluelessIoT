import paho.mqtt.client as mqtt

import ssl

def on_connect(client, userdata, flags, rc):
    if rc==0:
        client.connected_flag=True #set flag
        print("connected OK Returned code=",rc)
        #client.subscribe(topic)
    else:
        print("Bad connection Returned code= ",rc)

def on_message(client, userdata, message) :
	print("Received message:{} on topic {}".format(message.payload, message.topic))

def on_publish(client,userdata,result):
    print("Data published:{} \n".format(result))
    pass

client = mqtt.Client("", True, None, mqtt.MQTTv31)
client.on_connect = on_connect
client.on_publish = on_publish
client.on_message = on_message
client.username_pw_set(username="cluelessIoT",password="Imfresh") # broker does not allow anonymous connection
#client.tls_set()

#client.tls_set(ca_certs="mosquitto.org.crt",certfile="client.crt",keyfile="cli>

# ask Hyunjoon for the current IP address of the aws instance
IP_ADDRESS = "44.203.1.222"
PORT = 1883 # the default port number for mqtt

client.connect(IP_ADDRESS, PORT) # returns 0 if successful

# use function subscribe(topic) to receive messages on that topic 
# whenever a client publishes to that topic
client.subscribe("IC.embedded/cluelessIoT")

# use function publish(topic, message) to publish message
# to the specified topic
MSG_INFO = client.publish("IC.embedded/cluelessIoT","hello")

# loop function to keep the client listen to the broker
client.loop_forever()

mqtt.error_string(MSG_INFO.rc)

