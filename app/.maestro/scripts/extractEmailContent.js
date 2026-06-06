// Maestro only allows scripts in Javascript. Typescript is not currently supported.

/* global MAESTRO_MAIL_PROVIDER:readonly, MAESTRO_MAILPIT_URL:readonly, MAESTRO_RESEND_API_KEY:readonly */

const extractMagicLink = (html) => {
  const magicLinkPrefix = "app.sabr://auth/verify-token?token_hash=";
  const tokenHash = html.split(magicLinkPrefix)[1].split('"')[0];
  return `${magicLinkPrefix}${tokenHash}`;
};

const callAPI = (url, headers) => {
  const apiResponse = http.get(url, ...(headers ? [{ headers }] : []));

  if (!apiResponse.ok)
    throw new Error(
      `${MAESTRO_MAIL_PROVIDER} GET to ${url} failed: status=${apiResponse.status} body=${apiResponse.body}`,
    );

  return json(apiResponse.body);
};

const poll = (
  requestFn,
  shouldStopPolling,
  { attempt = 1, maxAttempts = 25 } = {},
) => {
  const value = requestFn();
  if (shouldStopPolling(value)) return value;

  if (attempt >= maxAttempts)
    throw new Error(`Poll failed after ${maxAttempts} attempts`);

  return poll(requestFn, shouldStopPolling, {
    attempt: attempt + 1,
    maxAttempts,
  });
};

const findMailpitTestEmail = (receivedEmails) =>
  receivedEmails.find(({ To }) =>
    To.some(({ Address }) => Address === output.auth.email.recipient),
  );

const extractMailpitEmailContent = () => {
  const mailpitBaseURL = `${MAESTRO_MAILPIT_URL}/api/v1`;
  const receivedEmails = poll(
    () => callAPI(`${mailpitBaseURL}/messages`).messages,
    // Must ensure email recipient is unique per test to avoid race conditions here
    findMailpitTestEmail,
  );

  const emailId = findMailpitTestEmail(receivedEmails).ID;

  const { Subject, HTML, From } = callAPI(
    `${mailpitBaseURL}/message/${emailId}`,
  );

  return {
    subject: Subject,
    body: HTML,
    link: extractMagicLink(HTML),
    senderName: From.Name,
    senderEmail: From.Address,
  };
};

const callResendAPI = (endpoint) =>
  callAPI(`https://api.resend.com/${endpoint}`, {
    Authorization: `Bearer ${MAESTRO_RESEND_API_KEY}`,
  });

const findResendTestEmail = (receivedEmails) =>
  receivedEmails.find(({ to }) => to.includes(output.auth.email.recipient));

const extractResendEmailContent = () => {
  const receivedEmails = poll(
    () => callResendAPI("emails/receiving").data,
    // Must ensure email recipient is unique per test to avoid race conditions here
    findResendTestEmail,
  );

  const emailId = findResendTestEmail(receivedEmails).id;

  const { subject, html, headers, from } = callResendAPI(
    `emails/receiving/${emailId}`,
  );

  return {
    subject,
    body: html,
    link: extractMagicLink(html),
    senderName: headers.from.split("<")[0].replace(/"/g, "").trim(),
    senderEmail: from,
  };
};

const extractEmailContent = () => {
  const providers = {
    mailpit: extractMailpitEmailContent,
    resend: extractResendEmailContent,
  };
  return providers[MAESTRO_MAIL_PROVIDER]();
};

output.auth.email = {
  ...output.auth.email,
  ...extractEmailContent(),
};
