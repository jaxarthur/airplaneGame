using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public GameObject player;
    public Vector3 positionOffset;
    public Vector3 rotationOffset;

    public float posSpeed;
    public float rotSpeed;

    private Vector3 newPos;
    private Quaternion newRot;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        newPos = player.transform.position + player.transform.up * positionOffset.y + player.transform.forward * positionOffset.z + player.transform.right * positionOffset.x;
        transform.position = Vector3.Lerp(transform.position, newPos, posSpeed);

        newRot = player.transform.rotation * Quaternion.Euler(rotationOffset);
        transform.rotation = Quaternion.Lerp(transform.rotation, newRot, rotSpeed);
    }
}
