const functions = require("firebase-functions");

const stripe = require('stripe')('sk_test_51Ls8gLASsoBJK28ld8JRnCzqnHBLS0aRHphrAOtkzKTVZJNItQNFxDN3DojFzFX7m8b9C4bEnBPqp5pBNkaEeZ3A00jBgNxw2r');

exports.createOrRetrieveCustomer = functions.https.onRequest(async (req, res) => {
  try {
    let customer;
    let accountUrl;
    let customerId;
    let accountAlrExists = false;
    const accountsList = await stripe.accounts.list();

    if (accountsList.data.length > 0) {
      for (const account of accountsList.data) {
        if (account.email === req.body.email) {
          customer = account;
          customerId = account.id;
          accountAlrExists = true;
          break;
        }
      }
    }

    if (!accountAlrExists) {
      customer = await stripe.accounts.create({
        type: 'express',
        business_type: 'individual',
        email: req.body.email,
        capabilities: {
          card_payments: { requested: true },
          transfers: { requested: true },
        },
        business_profile: {
          name: req.body.name, mcc: 7278, url: 'arnavjaiswal.com', product_description: '-',
        },
        individual: {
          email: req.body.email, "address": {
            "city": "Singapore",
            "country": "SG",
            "line1": "",
            "postal_code": "",
            "state": null
          }, dob: { day: 14, month: 9, year: 2002 }
        }
      });
      accountUrl = await stripe.accountLinks.create({
        account: customer.id,
        refresh_url: `https://api/stripe/account/reauth?account_id=${customer.id}`,
        return_url: 'work',
        type: 'account_onboarding',
      });
      customerId = customer.id;

    }
    res.status(200).send({
      details: customer,
      customer: customerId,
      accountUrl: accountUrl ? accountUrl.url : 'NA',
      success: true,
      stripeAccountExists: accountAlrExists
    });

  } catch (error) {
    res.status(404).send({ success: false, error: error.message });
  }
});

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    // Creates a temporary secret key linked with the customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: req.body.customerId },
      { apiVersion: '2020-08-27' }
    );

    // Creates a new payment intent with amount passed in from the client
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(req.body.amount),
      currency: req.body.currency,
      customer: req.body.customerId,
    });

    res.status(200).send({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      success: true
    });
  } catch (error) {
    res.status(404).send({ success: false, error: error.message });
  }
});
