using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(UnityEngine.Networking.NetworkManager))]

public class StartGame : MonoBehaviour
{
    public Button hostButton;
    public Button joinButton;

    private GameObject NetworkManager;
    private CustomNetworkManager NetworkManagerScript;

    // Start is called before the first frame update
    void Start()
    {
        NetworkManager = GameObject.Find("NetworkManager");
        NetworkManagerScript = NetworkManager.GetComponent<CustomNetworkManager>();
        hostButton.onClick.AddListener(hostGame);
        joinButton.onClick.AddListener(joinGame);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void hostGame()
    {
        NetworkManagerScript.StartHost();

    }

    void joinGame()
    {
        NetworkManagerScript.StartClient();
    }
}
