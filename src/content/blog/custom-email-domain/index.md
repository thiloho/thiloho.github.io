---
title: "Custom email domain"
description: "Find out how having your own domain can save you a lot of time when switching email providers."
pubDate: "2025-04-28"
modDate: "2025-04-29"
---

## Introduction

Most people choose a popular email provider, such as Gmail, and stick with it for a long time. That's fine and it works, but what if you want to switch to another one? You have dozens or even hundreds of accounts and now you have to log in to each one and change your email address to your new one, which takes a while.

This whole process can be greatly simplified for the future by using a custom domain for your email, which is what I will be covering in this article.

## How it works

If a provider has implemented this custom email domain feature, which many do (e.g. [Proton custom domain](https://proton.me/support/custom-domain) or [Tuta domain name](https://tuta.com/blog/own-domain-email)), and you have purchased a domain from a domain registrar (e.g. [Porkbun](https://porkbun.com/products/domains)), the process works as follows:

1. Add your domain from your email provider's dashboard
2. Navigate to the domain via your domain registrar's dashboard
3. Insert some DNS records
   - `TXT` to prove that you are the owner of the domain, typically with the following content `<provider>-<verify>-<identifier>`
   - `CNAME` and `TXT` records (e.g. SPF or DMARC), which are used for the actual authentication with various security measures
4. Create arbitrary addresses for your domain, e.g. contact@domain.com and hello@domain.com
5. When someone sends an email to your custom domain address, the DNS `MX` records redirect it to your email provider's servers

You can check that you are receiving emails at your custom domain addresses by using https://sendtestemail.com.

## Changing provider

If you decide to change your email provider, you can set up a custom email domain with your new provider. For all your accounts, you can now change the primary email to your custom email domain, and if you ever decide to change providers again, all you have to do is change your DNS records, saving you a lot of time and hassle.

Note that some services do not allow you to edit your primary email, but if you contact technical support they may be able to do this for you.

## Conclusion

Having your own email domain makes it much easier to switch providers and offers other benefits such as increased credibility or enhanced branding. So if you are currently in the process of changing your email addresses on different accounts, think about having your own email domain; you will thank yourself when you need to switch providers again.
