const admin = require('firebase-admin')
const functions = require("firebase-functions");
admin.initializeApp();

const stripe = require('stripe')('sk_test_51Ls8gLASsoBJK28ld8JRnCzqnHBLS0aRHphrAOtkzKTVZJNItQNFxDN3DojFzFX7m8b9C4bEnBPqp5pBNkaEeZ3A00jBgNxw2r');


export const scheduleDocumentDeletion = functions.https.onCall(async (data, context) => {
  const documentPath = data.documentPath; // Extract the document path from the data parameter

  try {
    await admin.firestore().doc(documentPath).delete();
    console.log(`Document at path ${documentPath} deleted.`);
    return { success: true };
  } catch (error) {
    console.error(`Error deleting document: ${error}`);
    return { success: false, error: error.message };
  }
});

exports.createOrRetrieveCustomer = functions.https.onRequest(async (req, res) => {
  try {
    let account;
    let accountId;
    let accountAlrExists = false;
    const accountsList = await stripe.accounts.list();

    if (accountsList.data.length > 0) {
      for (const account of accountsList.data) {
        if (account.email === req.body.email) {
          account = account;
          accountId = account.id;
          accountAlrExists = true;
          break;
        }
      }
    }

    if (!accountAlrExists) {
      account = await stripe.accounts.create({
        type: 'express',
        business_type: 'individual',
        email: req.body.email,
        country: 'SG',
        capabilities: {
          card_payments: { requested: true },
          transfers: { requested: true },
        },
        business_profile: {
          name: req.body.name,
          mcc: 7278,
          product_description: '-',
          support_phone: req.body.phone,
        },
        individual: {
          email: req.body.email,
          first_name: req.body.first_name,
          last_name: req.body.last_name,
          phone: req.body.phone,
          gender: req.body.gender,
          address: {
            city: "Singapore",
            country: "SG",
            line1: "",
            postal_code: "",
            state: null
          },
          dob: { day: 14, month: 9, year: 2002 }
        }
      });
      accountId = account.id;
    }

    res.status(200).send({
      details: account,
      accountID: accountId,
      success: true,
      stripeAccountExists: accountAlrExists
    });

  } catch (error) {
    res.status(404).send({ success: false, error: error.message });
  }
});
exports.generateAccountLink = functions.https.onRequest(async (req, res) => {
  try {
    const accountUrl = await stripe.accountLinks.create({
      account: req.body.stripeAccId,
      refresh_url: `https://api/stripe/account/reauth?account_id=${req.body.stripeAccId}`,
      return_url: `https://api/stripe/account/reauth?account_id=${req.body.stripeAccId}`,
      type: 'account_onboarding',
    });

    res.status(200).send({
      accountUrl: accountUrl.url,
      success: true,
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

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
  const {paymentMethodId, items, currency, useStripeSdk} = req.body;
  const orderAmount = 1;

  try{
    if(paymentMethodId){
      const params = {
        amount: orderAmount,
        confirm: true,
        confirmation_method: 'manual',
        currency: currency,
        use_stripe_sdk: useStripeSdk
      }

      const intent = await stripe.paymentIntents.create(params);
      console.log(`Intent: ${intent}`)
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  }catch(e){
    return res.send({error: e.message})
  }
})

exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
  const {paymentIntentId} = req.body;
  try{
    if(paymentIntentId){
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400)
  }catch(e){
    return res.send({error: e.message})
  }
})

const generateResponse = function (intent) {
  switch(intent.status){
    case 'requires_action':
      return {
        clientSecret: intent.clientSecret,
        requiresAction: true,
        status: intent.status
      };
    
    case 'requires_payment_method':
      return{
        'error': 'Your card was denied, please provide a new payment method',
      };

    case 'succeeded':
      return {clientSecret: intent.clientSecret, status: intent.status};
  }

  return {error: 'Failed'}
}