using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float speed;
    public float expForce;
    public float expRadius;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.Translate(Vector3.forward * speed, Space.Self);
    }

    private void OnTriggerEnter(Collider other)
    {
        Collider[] hitColliders = Physics.OverlapSphere(transform.position, expRadius);

        for (var i=0; i < hitColliders.Length; i++)
        {
            var hitCollider = hitColliders[i];

            var hitRB = hitCollider.gameObject.GetComponent<Rigidbody>();

            if (hitRB != null && hitCollider.gameObject != gameObject) {
                hitRB.AddExplosionForce(expForce, transform.position, expRadius);
            }
        }
    }
}
