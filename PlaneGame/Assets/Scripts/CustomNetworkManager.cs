using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Networking;
public class CustomNetworkManager : NetworkManager
{
    public override void OnClientConnect(NetworkConnection conn)
    {
        ClientScene.AddPlayer(conn, 0);
    }


    public override void OnServerAddPlayer(NetworkConnection conn, short playerControllerId)
    {
        GameObject player = (GameObject)Instantiate(playerPrefab, Vector3.up * 5, Quaternion.identity);
        player.GetComponent<PlaneControl>().bodyColor = Color.HSVToRGB(Random.value, 1.0f, 1.0f);
        NetworkServer.AddPlayerForConnection(conn, player, playerControllerId);
        Debug.Log("Created Player");
    }
}