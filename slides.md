---
title: Where the Wild Cloud Things Are
author: Calvin Hendryx-Parker, CTO, Six Feet Up
date: Indy Cloud Conf 2019
---

# Story Time {data-background-image="images/bookshelf.jpg"}

::: notes
Love Angel's description of himself as a developer with operational tendancies

Many of you may know this story I'm about to tell you as a child, or as maintainer of *Cloud* infrastructure.


The day Dan wore his sysadmin suit and made mischief of one kind and another

His boss called him "Wild Thing!"
and Dan said "I hate the cloud"
so he was sent to the datacenter without eating anything

Photo Credit: https://www.flickr.com/photos/davidorban/2382181451
:::


# Grew {data-background-image="images/dan-datacenter.jpg"}

::: notes

That very night in his enterprise a cloud grew, and grew

until there were regions all around the globe delivering his applications.

:::

# and Grew {data-background-image="images/clouds.jpg"}

::: notes
Dan came to the place where the wild cloud things are,

- bus factor
- volatility
- precariousness
- wastefulness
:::

# Bus Factor {.monster data-background-image="images/bus_factor_monster.png"}

::: notes
# bus factor roared its terrible roar
## Until Dan said "BE STILL!" And tamed it with his magic tricks

You want to lower that bus factor to less than 1

* Is there a "guy" or wild thing
* Multiple cases where the guy who knew was let go or walked out the door
* What happens when he is on vacation?
* How do you defeat the bus factor
:::

# Simplify {data-background-image="images/rube_goldberg.jpg"}

::: notes
Probably the hardest, but one of the more rewarding.

* Leverage more cloud native tools
* refactor the application to microservices
* or the opposite
* Put in place repeatable systems
* Fix the build process to be fully automated

Photo Credit: https://www.flickr.com/photos/freshwater2006/693945631
:::

# AWS Cloud Native Architecture {.original data-background-image="images/aws_proxy_chain.png"}

::: notes
How do you go from the closet to the cloud.

Lift and Shift can work, but is inefficient and expensive

ND Migration

* Replace database with RDS
* Replace HAProxy and Varnish with ALB and CloudFront
* Share files with EFS vs NFS
* Backups made to S3
* Build images for releases to minimize downtime
:::

# Document {data-background-image="images/glyphs.jpg"}

::: notes
* make docs
* curate your docs
* update your docs
* cull old docs

Part of the culture
document how it should work and not what is broken

repeated, repeated, repeated
Ensuring traceability only way we can support clients for over 10 years

Photo Credit: https://www.flickr.com/photos/pmillera4/6744378745
:::


# {data-background-image="images/vault.jpg"}

## Management of Secrets

- Vault
- AWS Secrets Manager
- LastPass

::: notes

* Audit
* Rotate
* Programatic Retrieval (dynamic DB passwords)
* Vault has nice features

Photo Credit: https://www.flickr.com/photos/ninniane/8730950297
:::

---

<video controls class="stretch" src="images/lpass-env.mp4"></video>

---

# Cross Train {data-background-image="images/cross_train.jpg"}

::: notes
* Pair programming
* Code review
* show and share (expand here)
* Professional Development
* Knowledge Transfers
:::

# Volatility {.monster data-background-image="images/volatility_monster.png"}

::: notes
- volatility gnashed its terrible teeth
Until Dan said "BE STILL!" And tamed it with his magic tricks

How do we handle inexperience and gaining knowledge in the cloud

Ever shifting

AWS Docs are better, but still have "issues"
:::

# {.original data-background-image="images/cloudfront_pr.png"}

::: notes
https://github.com/awsdocs/amazon-cloudfront-developer-guide/pull/4
:::

# Accreditation {data-background-image="images/technical_cert.png"}

::: notes
is free
:::

# Meetups {data-background-image="images/indyaws_meetup.jpg"}

::: notes
All around, just need to show up and even speak!
:::

# Training {data-background-image="images/training_online.jpg"}

::: notes
Cloud Guru, Cloud Academy
:::

# Blogs and Podcasts {data-background-image="images/vbrownbag.png"}

* <https://aws.amazon.com/podcasts/aws-podcast/>
* <https://www.screaminginthecloud.com/>

::: notes
Need example podcasts to share
:::

# Precariousness {.monster data-background-image="images/precariousness_monster.png"}

::: notes
- precariousness rolled its terrible eyes
Until Dan said "BE STILL!" And tamed it with his magic tricks

all about reliability
:::

# Workload Monitoring {data-background-image="images/workload_monitor.png"}

::: notes
Prometheus
Grafana
Datadog
:::

# {.original data-background-image="images/workload_monitor.png"}

# Instrumentation {.stretch data-background-image="images/grafana_dashboard.png"}

<https://prometheus.io/docs/instrumenting/exporters/>

::: notes
Prometheus supports many common services
HAProxy
Varnish
...
:::

# {.original data-background-image="images/grafana_dashboard.png"}

::: notes
built into your app that hooks to your monitoring
:::

# Proactive Alerts {data-background-image="images/roadsigns.jpg"}

# Automation {data-background-image="images/boost.jpg"}

::: notes
Proactive maintenance or automation of the system provisioning
:::

# Wastefulness {.monster data-background-image="images/wastefulness_monster.png"}

::: notes
- wastefulness showed its terrible claws
Until Dan said "BE STILL!" And tamed it with his magic tricks
:::

# Monitoring Spend {data-background-image="images/spend_monitoring.jpg"}

::: notes
AWS Cost Explorer
reserves instances
:::

---

![](images/costs_explorer.png)

---

![](images/costs_breakdown.png)

---

![](images/costs_by_service.png)

---

![](images/costs_recommendations.png)

---

# Cloud Custodian {data-background-image="images/cleaning_tools.jpg"}

::: notes
show an example policy
:::

# Spin Down EC2

~~~ {.yaml}
policies:
  - name: offhours-stop-ec2
    mode:
      type: periodic
      schedule: "rate(1 hour)"
      role: arn:aws:iam::243886768005:role/cloud_custodian
    resource: ec2
    filters:
      - type: offhour
        default_tz: America/Indiana/Indianapolis
        offhour: 16
    actions:
      - stop
~~~

---

## Clean Up Vols

~~~ {.stretch .yaml}
policies:
    - name: ebs-mark-unattached-deletion
      resource: ebs
      comments: |
        Mark any unattached EBS volumes for deletion in 30 days.
        Volumes set to not delete on instance termination do have
        valid use cases as data drives, but 99% of the time they
        appear to be just garbage creation.
      filters:
        - Attachments: []
        - "tag:maid_status": absent
      actions:
        - type: mark-for-op
          op: delete
          days: 30
~~~

#

~~~ {.stretch .yaml}
policies:
    - name: ebs-unmark-attached-deletion
      resource: ebs
      comments: |
        Unmark any attached EBS volumes that were scheduled for deletion
        if they are currently attached
      filters:
        - type: value
          key: "Attachments[0].Device"
          value: not-null
        - "tag:maid_status": not-null
      actions:
        - unmark
    
    - name: ebs-delete-marked
      resource: ebs
      comments: |
        Delete any attached EBS volumes that were scheduled for deletion
      filters:
        - type: marked-for-op
          op: delete
      actions:
        - delete
~~~

# {.original data-background-image="images/crowned.jpg"}

::: notes
By staring into their yellow eyes without blinking once, Dan freightened the wild cloud things who called him the most wild thing of all.

And made him king of all wild cloud things.

And now cried Dan:
:::

# "Let the Wild Rompus Start!" {.semi-filtered data-background-image="images/rompus.jpg"}

# Questions?

## <calvin@sixfeetup.com>

[`@calvinhp`](https://twitter.com/calvinhp)
