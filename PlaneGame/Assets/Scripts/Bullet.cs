using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class Bullet : MonoBehaviour
{
    public float speed;
    public float expForce;
    public float expRadius;
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
            Collider[] hitColliders = Physics.OverlapSphere(transform.position, expRadius);

            for (var i = 0; i < hitColliders.Length; i++)
            {
                var hitCollider = hitColliders[i];

                var hitRB = hitCollider.gameObject.GetComponentInParent<Rigidbody>();

                if (hitRB != null && hitCollider.gameObject != gameObject)
                {
                    hitRB.AddExplosionForce(expForce, transform.position, expRadius);
                }
            }
        }
        destroySelf();
    }

    [Command]
    private void destroySelf()
    {
        NetworkServer.Destroy(gameObject);
    }
}
