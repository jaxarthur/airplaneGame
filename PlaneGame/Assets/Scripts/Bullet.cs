using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class Bullet : NetworkBehaviour
{
    public float speed;
    public float damage;
    public float TimeToLive;
    private float TimeAlive;
    public NetworkConnection owner;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.Translate(Vector3.forward * speed, Space.Self);

        TimeAlive += Time.deltaTime;

        if (TimeAlive > TimeToLive)
        {
            CmdDestroySelf();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponentInParent<Rigidbody>() != null)
        {
            other.gameObject.GetComponentInParent<PlaneControl>().health -= damage;

            if (other.gameObject.GetComponentInParent<PlaneControl>().health < 1)
            {
                Debug.Log(owner.address + "Is GOATED");
            }
        }
        CmdDestroySelf();
    }

    [Command]
    private void CmdDestroySelf()
    {
        NetworkServer.Destroy(gameObject);
    }
}
