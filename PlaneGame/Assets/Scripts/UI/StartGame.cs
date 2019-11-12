﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(UnityEngine.Networking.NetworkManager))]

public class StartGame : MonoBehaviour
{
    public Button hostButton;
    public Button joinButton;
    public Text ipOut;
    public InputField ipIn;

    private GameObject NetworkManager;
    private CustomNetworkManager NetworkManagerScript;

    // Start is called before the first frame update
    void Start()
    {
        NetworkManager = GameObject.Find("NetworkManager");
        NetworkManagerScript = NetworkManager.GetComponent<CustomNetworkManager>();
        hostButton.onClick.AddListener(hostGame);
        joinButton.onClick.AddListener(joinGame);

        ipOut.text = IPManager.GetLocalIPAddress();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void hostGame()
    {
        unloadMenu();
        NetworkServer.Reset();
        NetworkManagerScript.StartHost();

    }

    void joinGame()
    {
        unloadMenu();
        NetworkManagerScript.networkAddress = ipIn.text;
        NetworkManagerScript.StartClient();
    }

    void unloadMenu()
    {
        Debug.Log("Unloading Menu");
        SceneManager.SetActiveScene(SceneManager.GetSceneByName("Game"));
        SceneManager.UnloadSceneAsync("Menu");
    }

}

public static class IPManager
{
    public static string GetLocalIPAddress()
    {
        var host = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
        foreach (var ip in host.AddressList)
        {
            if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
            {
                return ip.ToString();
            }
        }

        throw new System.Exception("No network adapters with an IPv4 address in the system!");
    }
}