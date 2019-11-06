﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class PlaneControl : NetworkBehaviour
{
    //parent vars
    [SyncVar]
    private Rigidbody rb;
    [SyncVar]
    private GameObject prop;


    //input vars
    private float pitch;
    private float roll;
    private float yaw;
    private float fire0;
    private float fire1;
    private float fire2;
    private float stickyThrottle;
    private float floatingThrottle;
    private float lastStickyThrottle;
    private float lastFloatingThrottle;
    public float stickyThrottleSpeed;
    private float usedThrottle;
    private bool usingFloatingThrottle;

    //engine vars
    [SyncVar]
    public float maxEngineSpeed;
    [SyncVar]
    public float maxForce;
    [SyncVar]
    public float propSpeed;

    //control surface vars
    public float maxPitchForce;
    public float maxRollForce;
    public float maxYawForce;

    //wing vars
    public float maxLiftForce;
    public float liftForceRatio;
    public float noseLiftAmount;
    public float noseLiftLimit;

    //working vars
    [SyncVar]
    public Vector3 curVelocity;
    [SyncVar]
    public Vector3 curRotation;

    // Start is called before the first frame update
    void Start()
    {
       rb = gameObject.GetComponent<Rigidbody>();
        prop = gameObject.transform.Find("prop").gameObject;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (!isLocalPlayer)
        {
            return;
        }

        GetControl();

        ApplyForce();
    }

    private void GetControl()
    {
        pitch = Input.GetAxis("Vertical");
        roll = Input.GetAxis("Horizontal");
        yaw = Input.GetAxis("Yaw");
        fire0 = Input.GetAxis("Fire1");
        fire1 = Input.GetAxis("Fire2");
        fire2 = Input.GetAxis("Fire3");
        stickyThrottle = Input.GetAxis("ThrottleSticky");
        floatingThrottle = Input.GetAxis("ThrottleFloating");

        //throttle delegation
        if (floatingThrottle != lastFloatingThrottle)
        {
            usingFloatingThrottle = true;
        }

        if (stickyThrottle != lastStickyThrottle)
        {
            usingFloatingThrottle = false;
        }

        //sticky or floating throttle mechanics
        if (usingFloatingThrottle)
        {
            usedThrottle = (floatingThrottle + 1) / 2;
        }
        else {
            usedThrottle = Mathf.Clamp(usedThrottle + stickyThrottle * stickyThrottleSpeed, 0, 1);
        }

        
    }

    private void ApplyForce()
    {
        //engine controll
        curVelocity = rb.velocity;
        curRotation = transform.localEulerAngles;

        if (Mathf.Abs(curVelocity.x + curVelocity.y + curVelocity.z) < maxEngineSpeed)
        {
            rb.AddRelativeForce(Vector3.forward * maxForce * usedThrottle);
        }

        //spin Prop
        prop.transform.Rotate(Vector3.up * usedThrottle * propSpeed, Space.Self);

        //pitch
        transform.Rotate(Vector3.right * maxPitchForce * pitch, Space.Self);
        //roll
        transform.Rotate(Vector3.forward * maxRollForce * roll * -1, Space.Self);

        //yaw
        transform.Rotate(Vector3.up * maxYawForce * yaw, Space.Self);

        //lift
        rb.AddForce(Vector3.up * Mathf.Clamp(liftForceRatio * Mathf.Abs(curVelocity.x + curVelocity.y + curVelocity.z), 0, maxLiftForce));

        //nose lift on turns and inversions
        if (Mathf.Abs(transform.localEulerAngles.x) > noseLiftLimit)
        {
            rb.AddRelativeTorque(Vector3.right * Mathf.Abs(transform.localEulerAngles.x) * noseLiftAmount);
        }

    }
}
