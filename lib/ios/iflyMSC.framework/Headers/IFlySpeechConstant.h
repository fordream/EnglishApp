//
//  IFlySpeechConstant.h
//  MSCDemo
//
//  Created by iflytek on 5/9/14.
//  Copyright (c) 2014 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  公共常量类
 *  主要定义参数的key value值
 */
@interface IFlySpeechConstant : NSObject


#pragma mark - 参数设置key


/*!
 *  语音应用ID
 *  通过开发者网站申请
 *
 *  @return 语音应用IDkey
 */
+(NSString*)APPID;


/*!
 *  语言区域。
 *
 *  @return 语言区域key。
 */
+(NSString*)ACCENT;

/*!
 *  语言
 *  支持：zh_cn，zh_tw，en_us<br>
 *
 *  @return 语言key
 */
+(NSString*)LANGUAGE;

/*!
 *  返回结果的数据格式，
 *  可设置为json，xml，plain，默认为json。
 *
 *  @return 返回结果的数据格式key
 */
+(NSString*) RESULT_TYPE;

/*!
 *  应用领域。
 *
 *  @return 应用领域key
 */
+(NSString*)IFLY_DOMAIN;

/*!
 *  个性化数据上传类型
 *
 *  @return 个性化数据上传类型key
 */
+(NSString*)DATA_TYPE;

/*!
 *  语音输入超时时间
 *   单位：ms，默认30000
 *
 *  @return 语音输入超时时间key
 */
+(NSString*) SPEECH_TIMEOUT;

/*!
 *  网络连接超时时间
 *  单位：ms，默认20000
 *
 *  @return 网络连接超时时间key
 */
+(NSString*)NET_TIMEOUT;


/*!
 *  业务类型。
 *
 *  @return 业务类型key。
 */
+(NSString*)SUBJECT;

/*!
 *  扩展参数。
 *
 *  @return 扩展参数key。
 */
+(NSString*)PARAMS;

#pragma mark -  合成相关设置key
/*!
 *  合成及识别采样率。
 *
 *  @return 合成及识别采样率key。
 */
+(NSString*)SAMPLE_RATE;

/*!
 *  语速
 *  范围 （0~100） 默认值:50
 *
 *  @return 语速key
 */
+(NSString*)SPEED;

/*!
 *  音调
 *  范围（0~100）默认值:50
 *
 *  @return 音调key
 */
+(NSString*)PITCH;

/*!
 *  合成录音保存路径
 *
 *  @return 合成录音保存路径key
 */
+(NSString*)TTS_AUDIO_PATH;

/*!
 *  VAD前端点超时
 *  范围：0-10000(单位ms)
 *
 *  @return VAD前端点超时key
 */
+(NSString*)VAD_BOS;

/*!
 *  VAD后端点超时 。
 *  可选范围：0-10000(单位ms)
 *
 *  @return VAD后端点超时key
 */
+(NSString*)VAD_EOS;

/*
 *  云端支持如下发音人：
 *  对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。
 *
 *  |--------|----------------|
 *  |  发音人 |  参数          |
 *  |--------|----------------|
 *  |  小燕   |   xiaoyan     |
 *  |--------|----------------|
 *  |  小宇   |   xiaoyu      |
 *  |--------|----------------|
 *  |  凯瑟琳 |   catherine   |
 *  |--------|----------------|
 *  |  亨利   |   henry       |
 *  |--------|----------------|
 *  |  玛丽   |   vimary      |
 *  |--------|----------------|
 *  |  小研   |   vixy        |
 *  |--------|----------------|
 *  |  小琪   |   vixq        |
 *  |--------|----------------|
 *  |  小峰   |   vixf        |
 *  |--------|----------------|
 *  |  小梅   |   vixl        |
 *  |--------|----------------|
 *  |  小莉   |   vixq        |
 *  |--------|----------------|
 *  |  小蓉   |   vixr        |
 *  |--------|----------------|
 *  |  小芸   |   vixyun      |
 *  |--------|----------------|
 *  |  小坤   |   vixk        |
 *  |--------|----------------|
 *  |  小强   |   vixqa       |
 *  |--------|----------------|
 *  |  小莹   |   vixyin      |
 *  |--------|----------------|
 *  |  小新   |   vixx        |
 *  |--------|----------------|
 *  |  楠楠   |   vinn        |
 *  |--------|----------------|
 *  |  老孙   |   vils        |
 *  |--------|----------------|
 */

/*!
 *  发音人
 *  <table>
 *  <thead>
 *  <tr><th>*云端发音人名称</th><th><em>参数</em></th>
 *  </tr>
 *  </thead>
 *  <tbody>
 *  <tr><td>小燕</td><td>xiaoyan</td></tr>
 *  <tr><td>小宇</td><td>xiaoyu</td></tr>
 *  <tr><td>凯瑟琳</td><td>catherine</td></tr>
 *  <tr><td>亨利</td><td>henry</td></tr>
 *  <tr><td>玛丽</td><td>vimary</td></tr>
 *  <tr><td>小研</td><td>vixy</td></tr>
 *  <tr><td>小琪</td><td>vixq</td></tr>
 *  <tr><td>小峰</td><td>vixf</td></tr>
 *  <tr><td>小梅</td><td>vixl</td></tr>
 *  <tr><td>小莉</td><td>vixq</td></tr>
 *  <tr><td>小蓉(四川话)</td><td>vixr</td></tr>
 *  <tr><td>小芸</td><td>vixyun</td></tr>
 *  <tr><td>小坤</td><td>vixk</td></tr>
 *  <tr><td>小强</td><td>vixqa</td></tr>
 *  <tr><td>小莹</td><td>vixying</td></tr>
 *  <tr><td>小新</td><td>vixx</td></tr>
 *  <tr><td>楠楠</td><td>vinn</td></tr>
 *  <tr><td>老孙</td><td>vils</td></tr>
 *  </tbody>
 *  </table>
 *
 *  @return 发音人key
 */
+(NSString*)VOICE_NAME;

/*!
 *  音量
 *  范围（0~100） 默认值:50
 *
 *  @return 音量key
 */
+(NSString*)VOLUME ;

/*!
 *  合成音频播放缓冲时间
 *    即缓冲多少秒音频后开始播放，如tts_buffer_time=1000;
 *  默认缓冲1000ms毫秒后播放。
 *
 *  @return 合成音频播放缓冲时间缓冲时间key
 */
+(NSString*)TTS_BUFFER_TIME ;

/*!
 *  引擎类型。
 *    可选：local，cloud，auto
 *  默认：auto
 *
 *  @return 引擎类型key。
 */
+(NSString*)ENGINE_TYPE;

/*!
 *  录音源
 *    录音时的录音方式，默认为麦克风，设置为1；
 *  如果需要外部送入音频，设置为-1，通过WriteAudio接口送入音频。
 *
 *  @return 录音源key
 */
+(NSString*)AUDIO_SOURCE;

#pragma mark - 识别、听写、语义相关设置key
/*!
 *  识别录音保存路径
 *
 *  @return 识别录音保存路径key
 */
+(NSString*) ASR_AUDIO_PATH;

/*!
 *  设置是否开启语义
 *
 *  @return 设置是否开启语义key
 */
+(NSString*)ASR_SCH;

/*!
 *  设置是否有标点符号
 *
 *  @return 设置是否有标点符号key
 */
+(NSString*)ASR_PTT;

/*!
 *  本地语法名称。
 *    本地语法名称，对应云端的有CLOUD_GRAMMAR
 *
 *  @return 本地语法名称key。
 */
+(NSString*)LOCAL_GRAMMAR;

/*!
 *  云端语法ID。
 *  云端编译语法返回的表示，早期版本使用GRAMMAR_ID，仍然兼容，但建议使用新的。
 *
 *  @return 云端语法ID key。
 */
+(NSString*)CLOUD_GRAMMAR;

/*!
 *  语法类型
 *
 *  @return 语法类型key
 */
+(NSString*)GRAMMAR_TYPE;

/*!
 *  语法内容。
 *
 *  @return 语法内容key。
 */
+(NSString*)GRAMMAR_CONTENT;

/*!
 *  字典内容。
 *
 *  @return 字典内容key。
 */
+(NSString*)LEXICON_CONTENT;

/*!
 *  字典名字。
 *
 *  @return 字典名字key。
 */
+(NSString*)LEXICON_NAME;

/*!
 *  语法名称列表。
 *
 *  @return 语法名称列表key。
 */
+(NSString*)GRAMMAR_LIST;

/*!
 *  编码格式。
 *
 *  @return 编码格式key。
 */
+(NSString*)TEXT_ENCODING;

/*!
 *  结果编码格式。
 *
 *  @return 结果编码格式key。
 */
+(NSString*)RESULT_ENCODING;

/*!
 *  本地识别引擎。
 *
 *  @return 本地识别引擎value。
 */
+(NSString*)TYPE_LOCAL;

/*!
 *  云端识别引擎。
 *
 *  @return 云端识别引擎value。
 */
+(NSString*)TYPE_CLOUD;

/*!
 *  混合识别引擎。
 *
 *  @return 混合识别引擎value。
 */
+(NSString*)TYPE_MIX;

/*!
 *  引擎根据当前配置进行选择。
 *
 *  @return 引擎根据当前配置进行选择value。
 */
+(NSString*)TYPE_AUTO;

/*!
 *  开放语义协议版本号。
 *  如需使用请在http://osp.voicecloud.cn/上进行业务配置
 *
 *  @return 开放语义协议版本号key。
 */
+(NSString*)NLP_VERSION;

#pragma mark -  唤醒相关设置key
/*!
 *  唤醒门限值。
 *
 *  @return 唤醒门限值key。
 */
+(NSString*)IVW_THRESHOLD;

/*!
 *  唤醒服务类型。
 *
 *  @return 唤醒服务类型key。
 */
+(NSString*)IVW_SST;

/*!
 *  唤醒+识别。
 *
 *  @return 唤醒+识别key。
 */
+(NSString*)IVW_ONESHOT;

/*!
 *  唤醒工作方式
 *    1：表示唤醒成功后继续录音，0：表示唤醒成功后停止录音。
 *
 *  @return 唤醒工作方式key
 */
+(NSString*)KEEP_ALIVE;

#pragma mark -  评测相关设置key
/*!
 *  评测类型<br>
 *   可选值：read_syllable(英文评测不支持):单字;read_word:词语;read_sentence:句子;read_chapter(待开放):篇章。
 *
 *  @return 评测类型 key
 */
+(NSString*)ISE_CATEGORY;

/*!
 *  评测结果等级<br>
 *    可选值：complete：完整 ；plain：简单
 *
 *  @return 评测结果等级 key
 */
+(NSString*)ISE_RESULT_LEVEL;

/*!
 *  评测结果格式
 *    可选值：xml;plain
 *
 *  @return 评测结果格式 key
 */
+(NSString*)ISE_RESULT_TYPE;


@end
