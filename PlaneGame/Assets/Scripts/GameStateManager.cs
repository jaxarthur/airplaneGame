using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class GameStateManager : NetworkBehaviour
{
    private IReadOnlyCollection<NetworkConnection> connections;
    [SyncVar]
    private List<NetworkConnection> trackedConnections = new List<NetworkConnection>();

    [SyncVar]
    public List<CustomPlayer> players = new List<CustomPlayer>();

    private Transform canvas;
    private List<Transform> scoreBoardTiles = new List<Transform>();

    public GameObject ScoreTileObject;

    public int topSpacing;
    public int leftSpacing;
    public int seperation;

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
            var child = canvas.GetChild(i);

            if (child.GetComponent<ScoreTileManager>() != null)
            {
                scoreBoardTiles.Add(child);
            }
        }

        foreach(Transform ScoreTile in scoreBoardTiles)
        {
            if (!trackedConnections.Contains(ScoreTile.GetComponent<ScoreTileManager>().conn))
            {
                RemoveScoreTile(ScoreTile);
            }
        }

        foreach (NetworkConnection connection in trackedConnections)
        {
            var addConnection = true;

            foreach (Transform ScoreTile in scoreBoardTiles)
            {
                if (ScoreTile.GetComponent<ScoreTileManager>().conn == connection)
                {
                    addConnection = false;
                }
            }

            if (addConnection)
            {
                AddScoreTile(connection);
            }
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

    void AddScoreTile(NetworkConnection conn)
    {
        var obj = Instantiate(ScoreTileObject);
        var trans = obj.GetComponent<RectTransform>();
        var script = obj.GetComponent<ScoreTileManager>();
        
        obj.transform.SetParent(canvas);
        trans.anchoredPosition = new Vector3(leftSpacing, -(topSpacing + seperation * scoreBoardTiles.Count), 0);

        script.conn = conn;
        script.playerName = "HelloWorld!";
        script.updateScore();

    }

    void RemoveScoreTile(Transform tile)
    {
        Destroy(tile);
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
