using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Networking;

public class ScoreTileManager : MonoBehaviour
{
    public int playerPlace;
    public string playerName = "";
    public int playerScore;

    public int placeMaxLen;
    public int nameMaxLen;
    public int scoreMaxLen;

    public NetworkConnection conn;

    void updateScore()
    {
        var outputString = "";

        outputString = outputString.Insert(-1, padString(playerPlace.ToString(), placeMaxLen));
        outputString = outputString.Insert(-1, " ");
        outputString = outputString.Insert(-1, padString(playerName, nameMaxLen));
        outputString = outputString.Insert(-1, " ");
        outputString = outputString.Insert(-1, padString(playerScore.ToString(), scoreMaxLen));

        gameObject.GetComponentInChildren<Text>().text = outputString;
    }

    string padString(string inputString, int length)
    {
        var outputString = "";

        if (inputString.Length > length)
        {
            outputString = inputString.Substring(0, length);
        } else if (inputString.Length < length)
        {
            outputString = inputString.PadLeft(length - inputString.Length);
        } else
        {
            outputString = inputString;
        }

        return outputString;
    }
}
