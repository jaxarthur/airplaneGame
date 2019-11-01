using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StartGame : MonoBehaviour
{
    public Button startButton;
    public Button hostButton;
    public Button joinButton;

    public GameObject NetworkManager;
    public Component NetworkManagerScript;


    // Start is called before the first frame update
    void Start()
    {
        startButton.onClick.AddListener(startGame);
        hostButton.onClick.AddListener(hostGame);
        joinButton.onClick.AddListener(goToJoinMenu);

        NetworkManagerScript = NetworkManager.GetComponent<CustomNetworkManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void startGame()
    {
        NetworkManagerScript.StartHost();
    }

    void hostGame()
    {

    }

    void goToJoinMenu()
    {

    }
}
