using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MailKit.Security;
using MimeKit.Text;
using MimeKit;
using Newtonsoft.Json;
using MailKit.Net.Smtp;

namespace eKucniLjubimci.RabbitMQ.Email
{
    public class Receiver
    {
        public void StartReceiving()
        {
            ManualResetEvent manualEvent = new ManualResetEvent(false);
            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RabbitMQ_HostName") ?? "localhost",
                UserName = Environment.GetEnvironmentVariable("RabbitMQ_UserName") ?? "guest",
                Password = Environment.GetEnvironmentVariable("RabbitMQ_Password") ?? "guest",
                Port = int.Parse(Environment.GetEnvironmentVariable("RabbitMQ_Port") ?? "5672"),
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "eKucniljubimciQueue", durable: false, exclusive: false, autoDelete: false, arguments: null);

            var consumer = new EventingBasicConsumer(channel);            

                consumer.Received += (model, ea) =>
                {
                    byte[] body = ea.Body.ToArray();
                    string json = Encoding.UTF8.GetString(body);
                    rmqMailDetails receivedObject = JsonConvert.DeserializeObject<rmqMailDetails>(json);

                    Console.WriteLine($"\n [x] Received {receivedObject.EmailContent}");


                    var email = new MimeMessage();
                    email.From.Add(MailboxAddress.Parse(receivedObject.AdressFrom));
                    email.To.Add(MailboxAddress.Parse(receivedObject.AdressTo));
                    email.Subject = "RabbitMQ-eKucniLjubimci";
                    email.Body = new TextPart(TextFormat.Html) { Text = receivedObject.EmailContent };


                    using var smtp = new SmtpClient();
                    smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;
                    smtp.Connect(receivedObject.SmtpMail, receivedObject.MailPort, SecureSocketOptions.Auto);
                    smtp.Authenticate(receivedObject.AdressFrom, receivedObject.MailPassword);
                    smtp.Send(email);
                    smtp.Disconnect(true);

                    Console.WriteLine("Slanje maila uspjesno (provjeriti Ethereal)...");
                };            

            channel.BasicConsume(queue: "eKucniljubimciQueue", autoAck: true, consumer: consumer);
            manualEvent.WaitOne();


        }
    }
}
