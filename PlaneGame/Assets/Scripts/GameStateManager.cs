using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.Events;

public class GameStateManager : NetworkBehaviour
{
    private IReadOnlyCollection<NetworkConnection> connections;
    private List<NetworkConnection> trackedConnections;

    [SyncVar]
    public List<CustomPlayer> players;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (isServer)
        {
            ServerManagment();
        }

        if (isClient)
        {
            ClientManagment();
        }
    }

    void ServerManagment()
    {
        //Connection Managment
        connections = NetworkServer.connections;
        trackedConnections = new List<NetworkConnection> { };

        for (var i=0; i < players.Count; i++)
        {
            CustomPlayer player = players[i];
            trackedConnections.Add(player.connection);
        }

        foreach(NetworkConnection connection in connections)
        {
            if (!trackedConnections.Exists(connection.Equals))
            {
                AddPlayer(connection);
            }
        }

        foreach(NetworkConnection connection in trackedConnections)
        {
            
        }
    }

    void ClientManagment()
    {

    }

    void AddPlayer(NetworkConnection connection)
    {
        players.Add(new CustomPlayer(connection));
    }

    void RemovePlayer(NetworkConnection connection)
    {
        List<int> positionsInList = new List<int> { };

        for (var i=0; i < players.Count; i++)
        {
            CustomPlayer player = players[i];
            if (player.connection == connection)
            {
                positionsInList.Add(i);
            }
        }

        int amountRemoved = 0;

        for (var i = 0; i < positionsInList.Count; i++)
        {
            players.RemoveAt(positionsInList[i - amountRemoved]);
            amountRemoved += 1;
        }
    }
}

public class CustomPlayer
{
    [SyncVar]
    public NetworkConnection connection;
    [SyncVar]
    public string name;
    [SyncVar]
    public int kills;
    [SyncVar]
    public int deaths;
    [SyncVar]
    public int score;

    public CustomPlayer(NetworkConnection newconnection)
    {
        connection = newconnection;
        name = "placeholder";
        kills = 0;
        deaths = 0;
        score = 0;
    }
}
