using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class Bullet : MonoBehaviour
{
    public float speed;
    public float damage;
    public float TimeToLive;
    private float TimeAlive;

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
            destroySelf();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponentInParent<Rigidbody>() != null)
        {
            other.gameObject.GetComponentInParent<PlaneControl>().health -= damage;
        }
        destroySelf();
    }

    [Command]
    private void destroySelf()
    {
        NetworkServer.Destroy(gameObject);
    }
}
