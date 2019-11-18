using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class GameStateManager : NetworkBehaviour
{
    private IReadOnlyCollection<NetworkConnection> connections;
    private List<NetworkConnection> trackedConnections = new List<NetworkConnection>();

    [SyncVar]
    public List<CustomPlayer> players = new List<CustomPlayer>();

    private Transform canvas;
    private List<Transform> scoreBoardTiles = new List<Transform>();

    public 

    // Start is called before the first frame update
    void Start()
    {
        if (isClient)
        {
            canvas = GameObject.Find("ScoreBoard").transform;
        }
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

        foreach (CustomPlayer player in players)
        {
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
            var removeConnection = true;

            foreach(NetworkConnection other in connections)
            {
                if (connection == other)
                {
                    removeConnection = false;
                }
            }

            if (removeConnection)
            {
                RemovePlayer(connection);
            }
        }
    }

    void ClientManagment()
    {
        scoreBoardTiles = new List<Transform>();
        //Score Board Managment
        for (int i = 0; i < canvas.childCount; i++)
        {
            scoreBoardTiles.Add(canvas.GetChild(i));
        }


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
