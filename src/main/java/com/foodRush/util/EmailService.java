package com.foodRush.util;

import java.io.InputStream;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Service to dispatch real transactional emails (like Password Reset OTP)
 * via SMTP (e.g. Gmail SMTP, SendGrid, Brevo, or custom mail server).
 */
public class EmailService {

	private static final Properties config = new Properties();
	private static boolean initialized = false;

	static {
		loadConfiguration();
	}

	public static synchronized void loadConfiguration() {
		InputStream in = null;
		try {
			// 1. Thread context classloader
			ClassLoader tcl = Thread.currentThread().getContextClassLoader();
			if (tcl != null) {
				in = tcl.getResourceAsStream("email.properties");
				if (in == null) {
					in = tcl.getResourceAsStream("/email.properties");
				}
			}

			// 2. Class classloader
			if (in == null && EmailService.class.getClassLoader() != null) {
				in = EmailService.class.getClassLoader().getResourceAsStream("email.properties");
				if (in == null) {
					in = EmailService.class.getClassLoader().getResourceAsStream("/email.properties");
				}
			}

			// 3. Class direct resource
			if (in == null) {
				in = EmailService.class.getResourceAsStream("/email.properties");
				if (in == null) {
					in = EmailService.class.getResourceAsStream("email.properties");
				}
			}

			// 4. File path fallback
			if (in == null) {
				String[] paths = {
					"c:/JavaSoftwares/javaWorkspaces/JEE_Workspace/JEE/src/main/resources/email.properties",
					"c:/JavaSoftwares/javaWorkspaces/JEE_Workspace/JEE/src/main/java/email.properties",
					"c:/JavaSoftwares/javaWorkspaces/JEE_Workspace/JEE/build/classes/email.properties"
				};
				for (String p : paths) {
					java.io.File f = new java.io.File(p);
					if (f.exists()) {
						in = new java.io.FileInputStream(f);
						break;
					}
				}
			}

			if (in != null) {
				config.load(in);
				System.out.println("[EmailService] Loaded configuration from email.properties");
			} else {
				System.out.println("[EmailService] Using built-in configured defaults.");
				config.setProperty("mail.smtp.host", "smtp.gmail.com");
				config.setProperty("mail.smtp.port", "587");
				config.setProperty("mail.smtp.auth", "true");
				config.setProperty("mail.smtp.starttls.enable", "true");
				config.setProperty("mail.from.name", "FoodRush Security");
				config.setProperty("mail.user", "rowtulokesh1123@gmail.com");
				config.setProperty("mail.password", "ltknpyivwefsyosb");
			}
		} catch (Exception e) {
			System.err.println("[EmailService] Error loading email.properties: " + e.getMessage());
		} finally {
			if (in != null) {
				try { in.close(); } catch (Exception ignore) {}
			}
		}
		initialized = true;
	}

	/**
	 * Checks if real SMTP credentials are provided
	 */
	public static boolean isConfigured() {
		String user = getProperty("mail.user");
		String pass = getProperty("mail.password");
		return user != null && !user.trim().isEmpty() && !user.contains("YOUR_EMAIL")
				&& pass != null && !pass.trim().isEmpty() && !pass.contains("YOUR_APP_PASSWORD");
	}

	public static String getSenderEmail() {
		return getProperty("mail.user");
	}

	private static String getProperty(String key) {
		String envVal = System.getenv(key.replace('.', '_').toUpperCase());
		if (envVal != null && !envVal.trim().isEmpty()) {
			return envVal.trim();
		}
		String sysVal = System.getProperty(key);
		if (sysVal != null && !sysVal.trim().isEmpty()) {
			return sysVal.trim();
		}
		return config.getProperty(key);
	}

	/**
	 * Sends a 6-digit OTP code to the recipient's real email address.
	 *
	 * @param recipientEmail destination email address (e.g. customer's registered email)
	 * @param otpCode 6-digit numeric verification code
	 * @return true if email was sent successfully; false otherwise
	 */
	public static boolean sendOtpEmail(String recipientEmail, String otpCode) {
		if (recipientEmail == null || recipientEmail.trim().isEmpty() || otpCode == null || otpCode.trim().isEmpty()) {
			return false;
		}

		if (!isConfigured()) {
			System.out.println("[EmailService] Real email sending skipped: SMTP credentials not set in email.properties.");
			return false;
		}

		final String host = getPropertyOrDefault("mail.smtp.host", "smtp.gmail.com");
		final String port = getPropertyOrDefault("mail.smtp.port", "587");
		final String username = getProperty("mail.user");
		final String password = getProperty("mail.password");
		final String fromName = getPropertyOrDefault("mail.from.name", "FoodRush Security");

		Properties props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.starttls.required", "true");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
		props.put("mail.smtp.ssl.trust", "*");
		props.put("mail.smtp.connectiontimeout", "10000");
		props.put("mail.smtp.timeout", "10000");

		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		try {
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(username, fromName));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail.trim()));
			message.setSubject("⚡ " + otpCode + " is your FoodRush Password Reset Code", "UTF-8");

			String htmlBody = ""
				+ "<div style=\"font-family: 'Segoe UI', Helvetica, Arial, sans-serif; max-width: 580px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);\">"
				+ "  <div style=\"background: linear-gradient(135deg, #E23744 0%, #B91C1C 100%); padding: 28px 24px; text-align: center;\">"
				+ "    <h1 style=\"color: #ffffff; margin: 0; font-size: 26px; font-weight: 800; letter-spacing: -0.5px;\">⚡ Food<span style=\"color: #FCD34D;\">Rush</span></h1>"
				+ "    <p style=\"color: rgba(255,255,255,0.9); margin: 6px 0 0; font-size: 14px;\">Password Reset Verification</p>"
				+ "  </div>"
				+ "  <div style=\"padding: 32px 28px; color: #1F2937;\">"
				+ "    <h2 style=\"font-size: 18px; margin-top: 0; color: #111827; font-weight: 700;\">Hello,</h2>"
				+ "    <p style=\"font-size: 14px; line-height: 1.6; color: #4B5563; margin-bottom: 24px;\">"
				+ "      We received a request to reset the password for your FoodRush account (<strong>" + recipientEmail + "</strong>). Use the verification code below to complete your reset:"
				+ "    </p>"
				+ "    <div style=\"text-align: center; margin: 28px 0;\">"
				+ "      <div style=\"display: inline-block; background-color: #FEE2E2; border: 2px dashed #EF4444; border-radius: 10px; padding: 16px 36px;\">"
				+ "        <span style=\"font-size: 32px; font-weight: 900; letter-spacing: 8px; color: #DC2626; font-family: monospace;\">" + otpCode + "</span>"
				+ "      </div>"
				+ "    </div>"
				+ "    <p style=\"font-size: 13px; color: #6B7280; text-align: center; margin-bottom: 24px;\">"
				+ "      ⏱️ This verification code is valid for <strong>10 minutes</strong>. Do not share this code with anyone."
				+ "    </p>"
				+ "    <hr style=\"border: none; border-top: 1px solid #E5E7EB; margin: 24px 0;\">"
				+ "    <p style=\"font-size: 12px; color: #9CA3AF; line-height: 1.5; margin: 0;\">"
				+ "      If you did not request this password reset, please ignore this email or contact support if you suspect unauthorized activity."
				+ "    </p>"
				+ "  </div>"
				+ "  <div style=\"background-color: #F9FAFB; padding: 16px 24px; text-align: center; font-size: 12px; color: #9CA3AF; border-top: 1px solid #E5E7EB;\">"
				+ "    © FoodRush Technologies Inc. • Fast, Fresh & Delicious at your doorstep."
				+ "  </div>"
				+ "</div>";

			message.setContent(htmlBody, "text/html; charset=UTF-8");
			Transport.send(message);
			System.out.println("[EmailService] Real OTP email sent successfully to: " + recipientEmail);
			return true;

		} catch (MessagingException e) {
			System.err.println("[EmailService] Failed to send real email to " + recipientEmail + ": " + e.getMessage());
			e.printStackTrace();
			return false;
		} catch (Exception e) {
			System.err.println("[EmailService] Unexpected error sending email: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	private static String getPropertyOrDefault(String key, String def) {
		String val = getProperty(key);
		return (val != null && !val.trim().isEmpty()) ? val.trim() : def;
	}

	public static void main(String[] args) {
		System.out.println("=== Testing FoodRush EmailService ===");
		loadConfiguration();
		System.out.println("Configured: " + isConfigured());
		System.out.println("Sender Email: " + getSenderEmail());
		if (isConfigured()) {
			System.out.println("Sending test OTP to " + getSenderEmail() + "...");
			boolean ok = sendOtpEmail(getSenderEmail(), "741852");
			System.out.println("Result: " + (ok ? "SUCCESS! Real email was delivered to your inbox!" : "FAILED to send email."));
		} else {
			System.out.println("SMTP is not configured.");
		}
	}
}
