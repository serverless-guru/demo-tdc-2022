declare module 'local' {
  import { IncomingHttpHeaders } from 'http';

  namespace Log {
    type Processes = 'process_personalization';

    type Others = 'link_router_is_not_a_bot';

    type HttpAPIs = 'http_post_get_product_offers' | 'http_gem_aem_view';

    type AwsAPIs =
      // v1 apis
      'aws_s3_select_guest_by_email_v1';

    interface MetricTags {
      Type: 'aws' | 'http' | 'process' | 'others';
    }

    type MetricActivity = HttpAPIs | LogHandlers | AwsAPIs | Processes | Others;

    type MetricType =
      | 'SuccessCount'
      | 'FailedCount'
      | 'SkipCount'
      | 'FallbackCount'
      | 'HitCount'
      | 'MissCount'
      | 'Duration'
      | 'Count';

    type LogLevels = 'debug' | 'http' | 'info' | 'warn' | 'error' | 'crit' | 'metric';

    interface LogMeta {
      /**
       * This is set by the loggify middlewarre for every invocation.
       */
      handler?: LogHandlers;
      /**
       * Log any type of data here
       */
      // @ts-expect-error
      data?: Record<unknown, unknown>;
      /**
       * Name of the entity, object, activity, process, resource, action that the reported metric belongs to.
       */
      activity?: MetricActivity;
      /**
       * Correlation Id.
       */
      cortexId?: string;
    }

    interface LogMetaMetric extends Pick<Log.LogMeta, 'cortexId'> {
      /**
       * Parent group that a metric belongs to
       */
      tags: Array<[name: keyof MetricTags, value: MetricTags[keyof MetricTags]]>;
      /**
       * Type of metric
       */
      name: MetricType;
      /**
       * Name of the entity, object, activity, process, resource, action that the reported metric belongs to.
       */
      activity: MetricActivity;
      /**
       * A metric value associated with the metric name.
       */
      value: number;
    }

    interface LogGlobalMeta extends Partial<Pick<LogMeta, 'handler' | 'cortexId'>> {}

    interface Logger {
      append: Log.LogGlobalMeta;
      debug: (message: string, meta?: Log.LogMeta) => void;
      http: (message: string, meta?: Log.LogMeta) => void;
      info: (message: string, meta?: Log.LogMeta) => void;
      warn: (message: string, e?: Error, meta?: Log.LogMeta & Required<Pick<LogMeta, 'activity'>>) => void;
      error: (message: string, e?: Error, meta?: Log.LogMeta & Required<Pick<LogMeta, 'activity'>>) => void;
      crit: (message: string, e?: Error, meta?: Log.LogMeta & Required<Pick<LogMeta, 'activity'>>) => void;
      metric: (meta: Log.LogMetaMetric) => void;
    }
  }

  export type Lang = 'en-US' | 'de-DE' | 'es-ES' | 'fr-FR' | 'ja-JP' | 'ko-KR' | 'pt-PT' | 'ru-RU' | 'zh-CN' | 'zh-HK';

  export type ReqQueryParams = Record<string, string | string[]>;
  export type ReqUrlParams = Record<string, string>;
  export type DDBFields = 'PK' | 'SK' | 'GSI1PK' | 'GSI1SK' | 'GSI2PK' | 'GSI2SK' | 'type' | 'GSI3PK' | 'GSI3SK';

  export type ReqResponse<T = unknown> = {
    body: T;
    statusCode?: number;
    cookie?: { name: string; value: string };
    headers?: Record<string, string>;
  };

  export interface ReqArgs<Body = unknown, Query = unknown> {
    body?: Body;
    cookies?: { adobeId: string; wohid: string };
    headers: IncomingHttpHeaders;
    urlParams: unknown;
    queryParams: Query;
  }
}
