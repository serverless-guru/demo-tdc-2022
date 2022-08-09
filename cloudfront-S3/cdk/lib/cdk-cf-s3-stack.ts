import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3'
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront'
import * as origin from 'aws-cdk-lib/aws-cloudfront-origins'
import * as route53 from 'aws-cdk-lib/aws-route53'
import * as targets from 'aws-cdk-lib/aws-route53-targets'
import * as acm from 'aws-cdk-lib/aws-certificatemanager'

export interface StaticSiteProps extends cdk.StackProps {
  domainName: string;
  siteSubDomain: string;
}
  
export class CdkCfS3Stack extends cdk.Stack {

  constructor(scope: cdk.App, id: string, props: StaticSiteProps) {
    super(scope, id, props);

    const siteDomain=`${props.siteSubDomain}.${props.domainName}`

    const websiteBucket = new s3.Bucket(this,'WebsiteBucket', {
      bucketName: siteDomain,
      publicReadAccess: true,
      blockPublicAccess: new s3.BlockPublicAccess({
        blockPublicAcls: false,
        blockPublicPolicy:false,
        ignorePublicAcls:false,
        restrictPublicBuckets:false,
      }),
      websiteIndexDocument: 'index.html',
      websiteErrorDocument: '404.html',
      removalPolicy: cdk.RemovalPolicy.DESTROY
    })

    const zone = route53.HostedZone.fromLookup(this, "Zone", {
      domainName: props.domainName
    });

    const certificate = new acm.DnsValidatedCertificate(this,"SiteCertificate",{
      domainName: siteDomain,
      hostedZone: zone,
      region: "us-east-1", // Cloudfront only checks this region for certificates.
    });

    const distribution = new cloudfront.Distribution(this, 'WebsiteDistribution', {
      enabled:true,
      enableIpv6:true,
      comment: siteDomain,
      domainNames:[siteDomain],
      httpVersion: cloudfront.HttpVersion.HTTP2,
      certificate: certificate,
      sslSupportMethod:cloudfront.SSLMethod.SNI,
      minimumProtocolVersion:cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
      defaultBehavior:{
        origin: new origin.HttpOrigin(websiteBucket.bucketWebsiteDomainName, {
          protocolPolicy:cloudfront.OriginProtocolPolicy.HTTP_ONLY
        }),
        allowedMethods:cloudfront.AllowedMethods.ALLOW_GET_HEAD,
        cachePolicy:cloudfront.CachePolicy.CACHING_OPTIMIZED,
        compress:true,
        viewerProtocolPolicy:cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS
      }
    })

    const DnsRecord = new route53.ARecord(this, "SiteAliasRecord", {
      recordName: siteDomain,
      target: route53.RecordTarget.fromAlias(
        new targets.CloudFrontTarget(distribution)
      ),
      zone,
    });
  }
}

